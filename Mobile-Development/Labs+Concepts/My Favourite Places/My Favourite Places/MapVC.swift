//
//  ViewController.swift
//  My Favourite Places
//
//  Created by Kian Palas on 02/12/2025.
//

import UIKit
import MapKit


class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("===\nLong Press began\n===")
            
            let touchPoint = sender.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            print(newCoordinate)
            
            let location = CLLocation(latitude: newCoordinate.latitude,
                                      longitude: newCoordinate.longitude)
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        } 
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                }
                
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                
                places.append([
                    "name": title,
                    "lat": String(newCoordinate.latitude),
                    "lon": String(newCoordinate.longitude)
                ])
                
                // save AFTER appending
                savePlaces()
                
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

          // If opened from a table row, show that place
          if currentPlace != -1,
             places.count > currentPlace,
             let lat = places[currentPlace]["lat"],
             let lon = places[currentPlace]["lon"],
             let name = places[currentPlace]["name"],
             let latitude = Double(lat),
             let longitude = Double(lon) {

              let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
              let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              let region = MKCoordinateRegion(center: coordinate, span: span)
              map.setRegion(region, animated: true)

              let annotation = MKPointAnnotation()
              annotation.coordinate = coordinate
              annotation.title = name
              map.addAnnotation(annotation)
          } else {
              // Opened from "+" – centre on Ashton Building [file:1]
              let coordinate = CLLocationCoordinate2D(latitude: 53.406566, longitude: -2.966531)
              let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
              let region = MKCoordinateRegion(center: coordinate, span: span)
              map.setRegion(region, animated: true)
          }    }

}

