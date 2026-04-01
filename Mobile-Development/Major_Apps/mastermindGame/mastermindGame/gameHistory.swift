

import Foundation

  

// MARK: - Game Record Structure

struct GameRecord: Codable {

    let id: UUID

    let date: Date

    let duration: TimeInterval

    let guessCount: Int

    let didWin: Bool

     


    init(duration: TimeInterval, guessCount: Int, didWin: Bool) {

        self.id = UUID()

        self.date = Date()

        self.duration = duration

        self.guessCount = guessCount

        self.didWin = didWin

    }

}

  

// MARK: - history management

class GameHistoryManager {

    private let key = "gameHistory"

     

    func saveRecord(_ record: GameRecord) {

        var history = loadHistory()

        history.append(record)

         

        if let encoded = try? JSONEncoder().encode(history) {

            UserDefaults.standard.set(encoded, forKey: key)

        }

    }

     

    func loadHistory() -> [GameRecord] {

        guard let data = UserDefaults.standard.data(forKey: key),

              let history = try? JSONDecoder().decode([GameRecord].self, from: data) else {

            return []

        }

        return history.sorted { $0.date > $1.date }

    }

     

    func clearHistory() {

        UserDefaults.standard.removeObject(forKey: key)

    }

}

