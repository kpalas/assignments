<?php
/** 
 * COMP284 Assignment 1: PHP
 * @author Kian Palas 201828270
 * 
 * Description:
 * Web-based applications that allow students to book tutorial sessions for their modules. 
 * Students can select a mdoule and time slot , name , email and submit a booking.
 * 
 * */ 

// Database connection parameters
$host = 'studdb';
$dbName = 'sgkpalas';    
$username = 'sgkpalas';  
$password = '';  

/** 
 * Creates and returns a PDO connection to the MySQL database.
 * 
 * @return PDO The PDO connection object.
 */
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbName;charset=utf8", 
                    $username, $password);
    // Makes PDO throw exceptions on errors
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}

/** 
 * Validates the name input.
 * 
 * @param string $name The name to validate.
 * @return bool True if the name is valid, false otherwise.
 */
function isNameValid($name) {
    // Must only contain letters, spaces, apostrophes, and hyphens
   if (!preg_match('/^[a-zA-Z\'\- ]+$/', $name)) {
      return false;
   }
   // Must start with a letter or apostrophe
   if (!preg_match('/^[a-zA-Z\']/', $name)) {
      return false;
   }
    // No two or more consecutive hyphens or apostrophes
   if (preg_match('/[\-\']{2,}/', $name)) {
      return false;
   }
   // Hyphens must only appear between letters (not at the start or end, and not adjacent to spaces or apostrophes)
   if (preg_match('/(?<![a-zA-Z])\-|\-(?![a-zA-Z])/', $name)) {
      return false;
   }
   return true;

}

/** 
 * Validates the email input based on these criteria:
 * - 1 "@" symbol
 * - Must start with a letter, digit, dot before this
 * - Followed by a non-empty sequence of letters ,digits or dots
 * - Neither the before or after @ ends in a dot
 * 
 * @param string $email The email to validate.
 * @return bool True if the email is valid, false otherwise.
 */
function isEmailValid($email) {
   return (bool) preg_match(
      '/^[a-zA-Z0-9.]+(?<!\.)@[a-zA-Z0-9.]+(?<!\.)$/',
      $email
   );

}

/**
 * Checks whether all tutorial sessions have no free places.
 * 
 * @param PDO $pdo The PDO connection object.
 * @return bool True if all sessions are full, false otherwise.
 */
function sessionFull($pdo) {
    $stmt = $pdo->query("SELECT COUNT(*) 
                        FROM tutorials 
                        WHERE freePlaces > 0");
    return $stmt->fetchColumn() == 0;
}

/**
 * Retrieves a list of distinct modules that have tutorial sessions with free places which is ordered alphabetically.
 * 
 * @param PDO $pdo The PDO connection object.
 * @return array An array of module names.
 */
function getModules($pdo) {
    $stmt = $pdo->query("SELECT DISTINCT module 
                        FROM tutorials 
                        WHERE freePlaces > 0 
                        ORDER BY module ASC");
    return $stmt->fetchAll(PDO::FETCH_COLUMN);
}

/** 
 * Retrieves a list of time slots for a given module that have free places which is ordered alphabetically.
 * 
 * @param PDO $pdo The PDO connection object.
 * @param string $module The module name.
 * @return array An array of time slots.
 */
function getTimes($pdo, $module) {
    $stmt = $pdo->prepare("SELECT id, day, time, location 
                            FROM tutorials 
                            WHERE module = :module AND freePlaces > 0 
                            ORDER BY FIELD(day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),time ASC");
    $stmt->execute([':module' => $module]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

/**
 * Retrieves all bookings from datatbase ordered by time booking was made.
 */
function getBookings($pdo) {
    $stmt = $pdo->query("SELECT name,email,module,day,time,location,bookedAt 
                        FROM bookings 
                        ORDER BY bookedAt ASC");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

/**
 * Attempts to book a tutorial session for a student.
 * Uses a database transaction with SELECT FOR UPDATE to prevent
 * race conditions when two users try to book the last place simultaneously.
 *
 * @param PDO $pdo The PDO connection object.
 * @param int $tutorialId The ID of the tutorial session to book.
 * @param string $name The student's name.
 * @param string $email The student's email address.
 * @return string 'success' if booked, 'full' if no places left, 'error' on failure.
 */
function bookTutorial($pdo, $tutorialId, $name, $email) {
    $pdo->beginTransaction();
    try {
        // locks row to prevent simulatenous bookings of the last place
        $stmt = $pdo->prepare("SELECT module, day, time, location, freePlaces 
                                FROM tutorials 
                                WHERE id = :id  
                                FOR UPDATE");
        $stmt->execute([':id' => $tutorialId]);
        $tutorial = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$tutorial || $tutorial['freePlaces'] <= 0) {
            $pdo->rollBack();
            return 'full';
        }
        // Decrement the free places for the tutorial session
        $stmt = $pdo->prepare("UPDATE tutorials 
                                SET freePlaces = freePlaces - 1 
                                WHERE id = :id");
        $stmt->execute([':id' => $tutorialId]);
        
        // Insert the booking into the bookings table
        $stmt = $pdo->prepare("INSERT INTO bookings (name, email, day, module, time, location) 
                                VALUES (:name, :email, :day, :module, :time, :location)");
        $stmt->execute([
            ':name'     => $name,
            ':email'    => $email,
            ':module'   => $tutorial['module'],
            ':day'      => $tutorial['day'],
            ':time'     => $tutorial['time'],
            ':location' => $tutorial['location']
        ]);

        // Commit the transaction
        $pdo->commit();
        return 'success';
    } catch (Exception $e) {
        // Roll back the transaction on error
        $pdo->rollBack();
        return 'error';
    }

}

// main logic
$errorMessage   = '';
$successMessage = '';
$submitted      = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_btn'])) {
    $submitted  = true;
    $name       = trim($_POST['name'] ?? '');
    $email      = trim($_POST['email'] ?? '');
    $module     = $_POST['module'] ?? '';
    $tutorialId = $_POST['tutorial'] ?? '';

    if (empty($name) || empty($email) || empty($module) || empty($tutorialId)) {
        $errorMessage = "All fields are required.";
    } else if (!isNameValid($name)) {
        $errorMessage = "Invalid name. Name must only contain letters, spaces, apostrophes, and hyphens, and must start with a letter or apostrophe.";
    } else if (!isEmailValid($email)) {
        $errorMessage = "Invalid email format."; 
    } else if (!ctype_digit($tutorialId)) {
        $errorMessage = "Invalid tutorial selection.";
    } else {
        $result = bookTutorial($pdo, (int) $tutorialId, $name, $email);
        if ($result === 'full') {
            $errorMessage = "Sorry, this tutorial session is full.";
        } else if ($result === 'error') {
            $errorMessage = "An error occurred while processing your booking. Please try again.";
        } else {
            $successMessage = "Your booking was successful!";
        }
    }
}

// check if all sessions are full 
$allFull = sessionFull($pdo);

// get modules with free places if not all sessions are full, otherwise set to empty array to prevent errors in the form
$modules = $allFull ? [] : getModules($pdo);

// use posted module if available and valid, otherwise default to first module in list
if (!empty($_POST['module']) && in_array($_POST['module'], $modules)) {
    $selectedModule = $_POST['module'];
} else {
    $selectedModule = $modules[0] ?? '';
}

// get available times for selected module
$times = !empty($selectedModule) ? getTimes($pdo, $selectedModule) : [];

// get all bookings if form has been submitted
$bookings = $submitted ? getBookings($pdo) : [];
?>

<!DOCTYPE html>
<html lang="en">
<head>
   <title>Tutorial Booking System</title>
   <style>
      body {
         font-family: Arial, sans-serif;
         max-width: 900px;
         margin: 40px auto;
         padding: 0 20px;
         background-color: #f9f9f9;
         color: #333;
      }
      h1 {
         border-bottom: 2px solid #003087;
         padding-bottom: 10px;
         color: #003087;
      }
      h2 {
         color: #003087;
         margin-top: 30px;
      }
      .message-error {
         color: #cc0000;
         background: #fff0f0;
         border: 1px solid #cc0000;
         padding: 10px 15px;
         border-radius: 4px;
         margin: 15px 0;
      }
      .message-success {
         color: #006600;
         background: #f0fff0;
         border: 1px solid #006600;
         padding: 10px 15px;
         border-radius: 4px;
         margin: 15px 0;
      }
      .message-full {
         color: #555;
         background: #f5f5f5;
         border: 1px solid #aaa;
         padding: 15px;
         border-radius: 4px;
      }
      form {
         background: #fff;
         border: 1px solid #ddd;
         padding: 20px 25px;
         border-radius: 6px;
      }
      label {
         display: block;
         margin-top: 15px;
         font-weight: bold;
      }
      select, input[type="text"] {
         display: block;
         margin-top: 5px;
         padding: 7px 10px;
         width: 100%;
         max-width: 400px;
         border: 1px solid #ccc;
         border-radius: 4px;
         font-size: 14px;
         box-sizing: border-box;
      }
      input[type="submit"] {
         display: block;
         margin-top: 20px;
         padding: 10px 25px;
         background-color: #003087;
         color: #fff;
         border: none;
         border-radius: 4px;
         font-size: 15px;
         cursor: pointer;
      }
      input[type="submit"]:hover {
         background-color: #00205b;
      }
      table {
         border-collapse: collapse;
         width: 100%;
         margin-top: 15px;
         background: #fff;
      }
      th {
         background-color: #003087;
         color: #fff;
         padding: 10px 12px;
         text-align: left;
      }
      td {
         padding: 9px 12px;
         border-bottom: 1px solid #ddd;
      }
      tr:nth-child(even) td {
         background-color: #f5f8ff;
      }
   </style>
</head>
<body>
 
   <h1>Tutorial Booking System</h1>
    <?php if ($allFull): ?>
        <p class="message-full">Sorry, all tutorial sessions are currently full.</p>
    <?php else: ?>
        <?php if (!empty($errorMessage)): ?>
            <p class="message-error"><?= htmlspecialchars($errorMessage) ?></p>
        <?php endif; ?>
        <?php if (!empty($successMessage)): ?>
            <p class="message-success"><?= htmlspecialchars($successMessage) ?></p>
        <?php endif; ?>
        <form method="POST" action="">
            <label for="module">Module:</label>
            <select name="module" id="module" onchange="this.form.submit()">
                <?php foreach ($modules as $mod): ?>
                    <option value="<?= htmlspecialchars($mod) ?>" <?= $mod === $selectedModule ? 'selected' : '' ?>>
                        <?= htmlspecialchars($mod) ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="tutorialID">Time and Location:</label>
            <select name="tutorial" id="tutorialID">
                <?php foreach ($times as $session): ?>
                    <option value="<?= htmlspecialchars($session['id']) ?>">
                        <?= htmlspecialchars($session['day'] . ', ' . $session['time'] . ' - ' . $session['location']) ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<?= htmlspecialchars($_POST['name'] ?? '') ?>">

            <label for="email">Email Address:</label>
            <input type="text" id="email" name="email" value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">

            <input type="submit" name="submit_btn" value="Submit">

        </form>
    <?php endif; ?>
    <?php if (!empty($bookings)): ?>
        <h2>Successful Bookings</h2>
        <table>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Module</th>
                <th>Day</th>
                <th>Time</th>
                <th>Location</th>
                <th>Booked At</th>
            </tr>
            <?php foreach ($bookings as $booking): ?>
                <tr>
                    <td><?= htmlspecialchars($booking['name']) ?></td>
                    <td><?= htmlspecialchars($booking['email']) ?></td>
                    <td><?= htmlspecialchars($booking['module']) ?></td>
                    <td><?= htmlspecialchars($booking['day']) ?></td>
                    <td><?= htmlspecialchars($booking['time']) ?></td>
                    <td><?= htmlspecialchars($booking['location']) ?></td>
                    <td><?= htmlspecialchars(date('Y-m-d H:i', strtotime($booking['bookedAt']))) ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
</body>
</html>