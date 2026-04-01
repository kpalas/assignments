//
//  ViewController.swift
//  mastermindGame
//
//  Created by Palas, Kian on 11/11/2025.
//


import UIKit

  

class ViewController: UIViewController {

     

    // MARK: - IBOutlets

    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var currentGuessStackView: UIStackView!

    @IBOutlet weak var guessHistoryTableView: UITableView!

    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var clearButton: UIButton!

    @IBOutlet weak var remainingGuessesLabel: UILabel!
    

    // MARK: - colour Buttons

    @IBOutlet weak var redButton: UIButton!

    @IBOutlet weak var blueButton: UIButton!

    @IBOutlet weak var greenButton: UIButton!

    @IBOutlet weak var greyButton: UIButton!

    @IBOutlet weak var yellowButton: UIButton!

    @IBOutlet weak var orangeButton: UIButton!

     

    // MARK: - properties

    var newGame = Game()

    var gameTimer: Timer?

    var colourButtons: [UIButton] = []

    var currentGuessView: [UIImageView] = []

    let historyManager = GameHistoryManager()

     

    // MARK: - view Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()

        setupTableView()

        startNewGame()

    }

     

    // MARK: - setupmethods

    private func setupUI() {

        colourButtons = [redButton, blueButton, greenButton, yellowButton, orangeButton, greyButton]

         

        // Setup navigation buttons

        navigationItem.rightBarButtonItem = UIBarButtonItem(

            title: "History",

            style: .plain,

            target: self,

            action: #selector(showHistory)

        )

         

        navigationItem.leftBarButtonItem = UIBarButtonItem(

            title: "New Game",

            style: .plain,

            target: self,

            action: #selector(startNewGame)

        )

         

        setupGuessSlots()

        updateUI()

    }

     

    private func setupTableView() {

        guessHistoryTableView.dataSource = self

        guessHistoryTableView.delegate = self


    }

     

    private func setupGuessSlots() {

        // Clear existing views

        currentGuessView.forEach { $0.removeFromSuperview() }

        currentGuessView = []

         

        // Create 4 image view slots

        for _ in 0..<4 {

            let imageView = UIImageView()

            imageView.backgroundColor = .lightGray

            imageView.layer.cornerRadius = 20

            imageView.layer.borderWidth = 2

            imageView.layer.borderColor = UIColor.darkGray.cgColor

            imageView.contentMode = .scaleAspectFit

             

            // Set fixed size

            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

            imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

             

            currentGuessStackView.addArrangedSubview(imageView)

            currentGuessView.append(imageView)

        }

    }

     

    // MARK: - Game Control

    @objc private func startNewGame() {

        newGame.startNewGame()

        updateCurrentGuessDisplay()

        startTimer()

        updateUI()

    }

     

    private func startTimer() {

        gameTimer?.invalidate()

        gameTimer = Timer.scheduledTimer(

            timeInterval: 1.0,

            target: self,

            selector: #selector(updateTimer),

            userInfo: nil,

            repeats: true

        )

    }

     

    @objc private func updateTimer() {

        let duration = newGame.getGameDuration()

        let minutes = Int(duration) / 60

        let seconds = Int(duration) % 60

        timerLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)

    }

     

    private func updateCurrentGuessDisplay() {

        for (index, imageView) in currentGuessView.enumerated() {

            if index < newGame.currentGuess.count {

                let colour = newGame.currentGuess[index]

                let imageName = colour.imageName

                imageView.image = UIImage(named: imageName)

                imageView.backgroundColor = .clear

            } else {

                imageView.image = nil

                imageView.backgroundColor = .lightGray

            }

        }

         

        submitButton.isEnabled = newGame.currentGuess.count == 4

        clearButton.isEnabled = !newGame.currentGuess.isEmpty

    }

     

    private func updateUI() {

        let remainingGuesses = newGame.getRemainingGuess()
        remainingGuessesLabel.text = "Remaining Guesses: \(remainingGuesses)"
        guessHistoryTableView.reloadData()

    }

     

    // MARK: - Button Actions

    @IBAction func colourButtonTapped(_ sender: UIButton) {

        guard newGame.isGameRunning else { return }

         

        let colourIndex = colourButtons.firstIndex(of: sender) ?? 0

        let colour = PegColour.allCases[colourIndex]

         

        if newGame.addPegtoCurrentGuess(colour) {

            updateCurrentGuessDisplay()

        }

    }

     

    @IBAction func clearButtonTapped(_ sender: UIButton) {

        newGame.clearCurrentGuess()

        updateCurrentGuessDisplay()

    }

     

    @IBAction func submitButtonTapped(_ sender: UIButton) {

        guard newGame.isGameRunning else { return }

         

        if let guess = newGame.submitCurrentGuess() {

            addGuessToHistory(guess)

            updateCurrentGuessDisplay()

            updateUI()

             

            if newGame.isGameWon(with: guess) {

                gameWon()

            } else if newGame.isGameLost() {

                gameLost()

            }

        }

    }

     

    @objc private func showHistory() {

        let historyVC = WinnersTableViewController()

        historyVC.historyManager = historyManager

        navigationController?.pushViewController(historyVC, animated: true)

    }

     

    // MARK: - Game Results

    private func gameWon() {

        newGame.isGameRunning = false

        gameTimer?.invalidate()

         

        let duration = newGame.getGameDuration()

        let record = GameRecord(

            duration: duration,

            guessCount: newGame.guessHistory.count,

            didWin: true

        )

        historyManager.saveRecord(record)

         

        let alert = UIAlertController(

            title: "Congratulations!",

            message: "You won in \(newGame.guessHistory.count) guesses! Time: \(formatTime(duration))",

            preferredStyle: .alert

        )

         

        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in

            self.startNewGame()

        }))

         

        alert.addAction(UIAlertAction(title: "View History", style: .default, handler: { _ in

            self.showHistory()

        }))

         

        present(alert, animated: true)

    }

     

    private func gameLost() {

        newGame.isGameRunning = false

        gameTimer?.invalidate()

         

        let record = GameRecord(

            duration: newGame.getGameDuration(),

            guessCount: newGame.guessHistory.count,

            didWin: false

        )

        historyManager.saveRecord(record)

         

        let secretCodeString = newGame.codemakerCode.map { $0.displayName }.joined(separator: ", ")

        let alert = UIAlertController(

            title: "Game Over",

            message: "The secret code was: \(secretCodeString)",

            preferredStyle: .alert

        )

         

        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in

            self.startNewGame()

        }))

         

        present(alert, animated: true)

    }

     

    private func addGuessToHistory(_ guess: Guess) {

        guessHistoryTableView.reloadData()

        let indexPath = IndexPath(row: newGame.guessHistory.count - 1, section: 0)

        guessHistoryTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

    }

     

    private func formatTime(_ timeInterval: TimeInterval) -> String {

        let minutes = Int(timeInterval) / 60

        let seconds = Int(timeInterval) % 60

        return String(format: "%02d:%02d", minutes, seconds)

    }

}

  

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return newGame.guessHistory.count

    }

     

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "guessHistoryCell", for: indexPath) as! GuessHistoryTableViewCell

         

        let guess = newGame.guessHistory[indexPath.row]

        cell.configureWith(guess: guess)

         

        return cell

    }

}

  

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70.0

    }

} 
