import Foundation

  

// MARK: - peg colour enum

enum PegColour: CaseIterable {

    case red, blue, green, yellow, orange, grey

     

    var displayName: String {

        switch self {

        case .red: return "Red"

        case .green: return "Green"

        case .blue: return "Blue"

        case .yellow: return "Yellow"

        case .orange: return "Orange"

        case .grey: return "Grey"

        }

    }

     

    // Image names

    var imageName: String {

        switch self {

        case .red: return "red"

        case .green: return "green"

        case .blue: return "blue"

        case .yellow: return "yellow"

        case .orange: return "orange"

        case .grey: return "grey"

        }

    }

}

  

// MARK: - guess structure

struct Guess {

    let pegs: [PegColour]

    let feedback: (exact: Int, colourOnly: Int)

}

  

// MARK: - main game class

class Game {

    // MARK: - properties

    var codemakerCode: [PegColour] = []

    var currentGuess: [PegColour] = []

    var guessHistory: [Guess] = []

    var timeStart: Date?

    var isGameRunning = false

    


    private let pegCount = 4

    private let maxGuesses = 10

     

    // MARK: - initialization

    init() {

        startNewGame()

    }

     

    // MARK: - game control

    func startNewGame() {

        generateCodemakerCode()

        currentGuess = []

        guessHistory = []

        timeStart = Date()

        isGameRunning = true

         

        print("Secret Code: \(codemakerCode.map { $0.displayName })")

    }

     

    private func generateCodemakerCode() {

        codemakerCode = (0..<pegCount).map { _ in

            PegColour.allCases.randomElement()!

        }

    }

    func getRemainingGuess() -> Int {
        return maxGuesses - guessHistory.count
    }
     

    // MARK: - game Logic

   
    
    func addPegtoCurrentGuess(_ colour: PegColour) -> Bool {

        guard currentGuess.count < pegCount else { return false }

        currentGuess.append(colour)

        return true

    }

     

    func removeLastPegfromCurrentGuess() {

        guard !currentGuess.isEmpty else { return }

        currentGuess.removeLast()

    }

     

    func clearCurrentGuess() {

        currentGuess = []

    }

     

    func submitCurrentGuess() -> Guess? {

        guard currentGuess.count == pegCount else { return nil }

         

        let feedback = checkGuess(currentGuess)

        let guess = Guess(pegs: currentGuess, feedback: feedback)

        guessHistory.append(guess)

         

        currentGuess = []

        return guess

    }

     

    private func checkGuess(_ guess: [PegColour]) -> (exact: Int, colourOnly: Int) {

        var exactMatch = 0

        var colourMatch = 0

         

        var codemakerTemp = codemakerCode

        var guessTemp = guess

         

        // Check exact matches

        for i in (0..<codemakerTemp.count).reversed() {

            if codemakerTemp[i] == guessTemp[i] {

                exactMatch += 1

                codemakerTemp.remove(at: i)

                guessTemp.remove(at: i)

            }

        }

         

        // Check colour only matches

        for guessColour in guessTemp {

            if let index = codemakerTemp.firstIndex(of: guessColour) {

                colourMatch += 1

                codemakerTemp.remove(at: index)

            }

        }

         

        return (exactMatch, colourMatch)

    }

     

    func isGameWon(with guess: Guess) -> Bool {

        return guess.feedback.exact == pegCount

    }

     

    func isGameLost() -> Bool {

        return guessHistory.count >= maxGuesses

    }

     

    func getGameDuration() -> TimeInterval {

        guard let start = timeStart else { return 0 }

        return Date().timeIntervalSince(start)

    }

     


} 
