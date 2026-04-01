//
//  ViewController.swift
//  Research Papers
//
//  Created by Kian Palas on 06/12/2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    
    var selectedReport: techReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let report = selectedReport {
            
            titleLabel.text = report.title
            yearLabel.text = "Year: \(report.year)"
            authorLabel.text = "Authors: \(report.authors)"
            emailLabel.text = "Email: \(report.email ?? "N/A")"
            abstractLabel.text = report.abstract ?? "None Available"
            
            if let pdfUrl = report.pdf {
                urlTextView.isHidden = false
                urlTextView.text = pdfUrl.absoluteString
                
                urlTextView.isEditable = false
                urlTextView.dataDetectorTypes = .link
                
                
            } else {
                urlTextView.isHidden = true
                
            }
            
        }
    }

}
