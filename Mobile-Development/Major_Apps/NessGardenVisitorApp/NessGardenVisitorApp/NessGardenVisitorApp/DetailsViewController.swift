//
//  DetailsViewController.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import Foundation
import UIKit
import MapKit

class DetailsViewController : UIViewController {
    //MARK: IBoutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var originMap: MKMapView!
    
    
    //MARK: Properties
    var plant: Plant?
    var ImageFileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup text
        
        if let p = plant {
            let genus = p.genus ?? ""
            let species = p.species ?? ""
            let common = p.vernacular_name ?? "Unknown Common Name"
            
            nameLabel.text = "\(genus) \(species) - \(common)"
            
            // description builder
            var details = "Common Name: \(common)\n"
            if let cult = p.cultivar_name {
                details += "Cultivar: \(cult)\n"
            }
            if let donor = p.donor { details += "Donor: \(donor)\n"}
            if let country = p.country { details += "Country: \(country)\n"}
            
            detailsTextView.text = details
            
            setupOriginMap(lat: p.latitude, lon: p.longitude)
        }
        if let fileName = ImageFileName {
            loadImage(fileName: fileName)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
    }
    
    func setupOriginMap(lat: String? , lon: String?) {
        // checks coordinates exist and are valid
        guard let latString = lat, let lonString = lon, let lat = Double(latString), let lon = Double(lonString), lat != 0.0, lon != 0.0 else {
            originMap.isHidden = true
            return
        }
        // shows map
        originMap.isHidden = false
        
        // creates pin
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Origin"
        originMap.addAnnotation(annotation)
        
        // zoom to pin
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 670000, longitudinalMeters: 670000)
        originMap.setRegion(region, animated: false)
        
    }
    
    func loadImage(fileName: String?) {
        let urlString = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness_images/"
        
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url.appendingPathComponent(fileName ?? "")), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        
    }
}
