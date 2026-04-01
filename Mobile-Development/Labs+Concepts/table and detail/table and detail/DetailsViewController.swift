//
//  DetailsViewController.swift
//  table and detail
//
//  Created by Palas, Kian on 22/10/2025.
//

import UIKit

class DetailsViewController: UIViewController {

    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var room: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    var Name : String?
    var Room : String?
    var Email : String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        name.text = Name
        room.text = Room
        email.text = Email
        
        
                
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
