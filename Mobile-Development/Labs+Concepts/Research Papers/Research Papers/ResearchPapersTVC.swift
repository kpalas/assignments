//
//  ResearchPapersTVC.swift
//  Research Papers
//
//  Created by Kian Palas on 06/12/2025.
//

import UIKit

class ResearchPapersTVC: UITableViewController {
    
    @IBOutlet var theTable: UITableView!
    
    var reports:technicalReports? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                    self.reports = reportList
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }.resume()
        }
    }    // MARK: - Table view data source
    
    func updateTheTable() {
        theTable.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports?.techreports2.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = reports?.techreports2[indexPath.row].title ?? "no title"
        content.secondaryText = reports?.techreports2[indexPath.row].authors ?? "no authors"
        cell.contentConfiguration = content
        return cell
        
        // Configure the cell...
    }
    
    // segue from table view to view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        performSegue(withIdentifier: "toDetail", sender: nil)
        
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "toDetail" {
            guard let destinationVC = segue.destination as? ViewController else {
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            destinationVC.selectedReport = reports?.techreports2[indexPath.row]
            
            
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        
        
    }
}
