//
//  ViewController.swift
//  table and detail
//
//  Created by Palas, Kian on 22/10/2025.
//

import UIKit





class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
        
    @IBOutlet weak var tableView : UITableView!
    
    
    var staff =
    [("Phil","A1.20","phil@liverpool.ac.uk"),("Terry","A2.18","trp@liverpool.ac.uk"),("Valli","A2.12","V.Tamma@liverpool.ac.uk"),("Boris","A1.15","Konev@liverpool.ac.uk")]
    var selectedStaff = ("","","")

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = staff[indexPath.row].0
        aCell.contentConfiguration = content
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStaff = staff[indexPath.row]
        performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    func tableView(_ tableView:UITableView , commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath ) {
        
        if editingStyle == .delete {
            staff.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func unwindToMainView(_ unwindSegue: UIStoryboardSegue) {
        let souceViewController = unwindSegue.source
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.Name = selectedStaff.0
            detailsViewController.Room = selectedStaff.1
            detailsViewController.Email = selectedStaff.2
            
        }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

