//
//  ViewController.swift
//  Core Data Example
//
//  Created by Kian Palas on 24/11/2025.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var contacts: [Contact] = [] //Empty array to hold records fetched from CoreData

    @IBAction func addContact(_ sender: Any) {
        let alert = UIAlertController(title: "New Contact", message: "Add a new contact",
        preferredStyle: .alert)
        alert.addTextField { textField in
        textField.placeholder = "First Name"
        }
        alert.addTextField { textField in
        textField.placeholder = "Last Name"
        }
        alert.addTextField { textField in textField.placeholder = "Phone Number"
            textField.keyboardType = .phonePad
            
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
        guard let firstNameField = alert.textFields?[0],
        let lastNameField = alert.textFields?[1],
        let phoneNumberField = alert.textFields?[2],
        let firstName = firstNameField.text,
        let lastName = lastNameField.text,
        let phoneNumber = phoneNumberField.text  else {
        return
        }
        self.saveData(theFirstName: firstName, theLastName: lastName, thePhoneNumber: phoneNumber)
        self.myTable.reloadData()
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
        
    }
    

    @IBOutlet weak var myTable: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for:
        indexPath)
        let contact = contacts[indexPath.row]
        var content = UIListContentConfiguration.cell()
        content.text = (contact.firstName ?? "") + " " + (contact.lastName ?? " ")
        content.secondaryText = contact.phoneNumber ?? "phone number"
        cell.contentConfiguration = content
        return cell
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Contact")
        do {
            contacts = try managedContext.fetch(fetchRequest) as! [Contact]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    func saveData(theFirstName: String, theLastName: String, thePhoneNumber: String ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedContext) as! Contact
        contact.firstName = theFirstName
        contact.lastName = theLastName
        contact.phoneNumber = thePhoneNumber
        
        do {
            try managedContext.save()
            contacts.append(contact)
            print("SAVED")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView:UITableView , commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath ) {
        
        if editingStyle == .delete {
            deleteContact(indexPath: indexPath)

        }
    }

    func deleteContact(indexPath: IndexPath) {
    // Delete the object from Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contactToDelete = contacts[indexPath.row]
        managedContext.delete(contactToDelete)
        do {
            try managedContext.save()
            // Remove the object from the array
            contacts.remove(at: indexPath.row)
            // Remove the table view row
            myTable.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
}

