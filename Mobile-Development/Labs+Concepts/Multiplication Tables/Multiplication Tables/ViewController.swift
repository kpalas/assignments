//
//  ViewController.swift
//  Multiplication Tables
//
//  Created by Palas, Kian on 22/10/2025.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField : UITextField!
    
    var multiplier :Int = 1
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        
        if indexPath.section == 0 {
            
            content.text = "\(indexPath.row + 1)  X \(multiplier) = \((indexPath.row + 1) * multiplier) "
            
        } else {
            let divider = indexPath.row + 1
            let result = Double(multiplier)/Double(divider)
            content.text = "\(multiplier) / \(divider) = \(String(format: "%.4f",result)) "

            
        }
        cell.contentConfiguration = content
        return cell
        
        
    }
    
    func showAlert(title: String , message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert,animated: true)

        
    }
    
    @IBAction func GoPressed(_ sender: UIButton) {
        inputField.resignFirstResponder( )
        guard let text = inputField.text, let num = Int(text) else {
            showAlert(title: "Invalid Input", message: "Please enter a number")
            return
        }
        multiplier = num
        tableView.isHidden = false
        tableView.reloadData( )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
    
        // Do any additional setup after loading the view.
    }
    

}

