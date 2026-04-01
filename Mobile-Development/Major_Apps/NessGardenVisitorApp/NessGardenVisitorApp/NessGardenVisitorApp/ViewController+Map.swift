//
//  ViewController+Map.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import Foundation
import MapKit
import UIKit

extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        // returns array of locations
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        //extracts the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //MARK: Inital Map setup
        
        
        if firstRun {
            firstRun = false
            
            //defines zoom level
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            
            //a span defines how large an area is depicted on the map.
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            //a region defines a centre and a size of area covered.
            let region = MKCoordinateRegion(center: location, span: span)
            
            //make the map show that region we just defined.
            self.myMap.setRegion(region, animated: true)
            
            //the following code is to prevent a bug which affects the zooming of the map to the user's location.
            //We have to leave a little time after our initial setting of the map's location and span,
            //before we can start centering on the user's location, otherwise the map never zooms in because the
            //intial zoom level and span are applied to the setCenter( ) method call, rather than our "requested" ones,
            //once they have taken effect on the map.
            
            //we setup a timer to set our boolean to true in 5 seconds.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        // if the timer has finished and enabled tracking, center the map on the user continuously.
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
        for i in 0..<tableSections.count {
            if let bedLoc = tableSections[i].bed.location {
                tableSections[i].distanceToUser = locations[0].distance(from: bedLoc)
            }
        }
        // sort so the closest bed is at the top
        tableSections.sort { $0.distanceToUser < $1.distanceToUser }
        myTable.reloadData()
    }
    
    //triggers timer
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    // shows route / adds overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue // Change color if needed
                renderer.lineWidth = 5.0           // Make it thick enough to see
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
}
