import UIKit

  

class WinnersTableViewController: UITableViewController {

     

    // MARK: - Properties

    var historyManager: GameHistoryManager!

    private var gameHistory: [GameRecord] = []

     

    // MARK: - Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()

        loadHistory()

    }

     

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        loadHistory()

    }

     

    // MARK: - Setup

    private func setupUI() {

        title = "Game History"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")

         

        navigationItem.rightBarButtonItem = UIBarButtonItem(

            title: "Clear",

            style: .plain,

            target: self,

            action: #selector(clearHistory)

        )

    }

     

    private func loadHistory() {

        gameHistory = historyManager.loadHistory()

        tableView.reloadData()

    }

     

    @objc private func clearHistory() {

        let alert = UIAlertController(

            title: "Clear History",

            message: "Are you sure you want to clear all game history?",

            preferredStyle: .alert

        )

         

        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in

            self.historyManager.clearHistory()

            self.loadHistory()

        }))

         

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

         

        present(alert, animated: true)

    }

     

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return gameHistory.count

    }

     

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

         

        let record = gameHistory[indexPath.row]

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short

        dateFormatter.timeStyle = .short

         

        let timeString = formatTime(record.duration)

        let result = record.didWin ? "Won" : "Lost"

         

        cell.textLabel?.text = "\(dateFormatter.string(from: record.date)) - \(result)"

        cell.detailTextLabel?.text = "Time: \(timeString) - Guesses: \(record.guessCount)"

        cell.textLabel?.numberOfLines = 0

         

        // Color coding for win/loss

        cell.backgroundColor = record.didWin ?

            UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0) :

            UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)

         

        return cell

    }

     

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80.0

    }

     

    private func formatTime(_ timeInterval: TimeInterval) -> String {

        let minutes = Int(timeInterval) / 60

        let seconds = Int(timeInterval) % 60

        return String(format: "%02d:%02d", minutes, seconds)

    }

}
