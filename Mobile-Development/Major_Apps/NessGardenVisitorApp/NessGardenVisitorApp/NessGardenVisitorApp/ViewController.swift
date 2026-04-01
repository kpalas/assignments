//
//  ViewController.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 07/12/2025.
//

import UIKit
import MapKit
import CoreLocation

// displays userlocation and table view through view controller

class ViewController: UIViewController {
    
    //MARK: IBOutlets Declaration
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var trailsButton: UIButton!
    //MARK: properties
    //handles GPS/location events
    var locationManager = CLLocationManager()
    
    // flag to ensure map zoom ensured once
    var firstRun = true
    
    // flag to determine if map should automatically center on the user location
    var startTrackingTheUser = false
    
    var allBeds: [Bed] = []
    var allPlants: [Plant] = []
    var allImages: [PlantImage] = []
    var plantImageMap: [String: String] = [:] // Helps find images fast
    var tableSections: [BedSection] = []       // The sorted data for the table
    var imageCache: [String: UIImage] = [:]
    
    //trail data
    var allTrails: [Trail] = []
    var allTrailLocations: [TrailLocation] = []
    
    func fetchData() {
        
        let group = DispatchGroup()
        
        // fetches bed
        group.enter()
        let bedURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=beds")!
        URLSession.shared.dataTask(with: bedURL) { data, response, error in
            defer { group.leave() }
            if let data = data {
                do {
                    let root = try JSONDecoder().decode(BedRoot.self, from: data)
                    DispatchQueue.main.async {
                        self.allBeds = root.beds
                        CoreDataManager.shared.saveBeds(self.allBeds)
                        print("Beds loaded: \(self.allBeds.count)")
                    }
                } catch { print("Error decoding beds: \(error)") }
            } else {
                DispatchQueue.main.async {
                    print("network failed for beds")
                    self.allBeds = CoreDataManager.shared.fetchBeds()
                }
            }
        } .resume()
        
        group.notify(queue: .main) {
            print("downloads finished. Starting processing...")
            self.processData()
        }
        //  fetch Plants
        group.enter()
        let plantURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=plants")!
        URLSession.shared.dataTask(with: plantURL) { data, response, error in
            defer { group.leave() }
            if let data = data {
                do {
                    let root = try JSONDecoder().decode(PlantRoot.self, from: data)
                    DispatchQueue.main.async {
                        CoreDataManager.shared.savePlants(self.allPlants)
                        self.allPlants = root.plants
                        print("plants loaded: \(self.allPlants.count)")
                    }
                } catch { print("Error decoding plants: \(error)") }
            } else {
                DispatchQueue.main.async {
                    print("network failed for plants")
                    self.allPlants = CoreDataManager.shared.fetchPlants()
                }
            }
        }.resume()
        
        // fetch Images
        group.enter()
        let imageURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=images")!
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            defer { group.leave() }
            if let data = data {
                do {
                    let root = try JSONDecoder().decode(ImageRoot.self, from: data)
                    DispatchQueue.main.async {
                        
                        self.allImages = root.images
                        print("images loaded: \(self.allImages.count)")
                    }
                } catch {
                    print("Error decoding images: \(error)")
                }
            }
        }.resume()
        
        // get trails
        
        group.enter()
        let trailsURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=trails")!
        URLSession.shared.dataTask(with: trailsURL) { data, response , error in defer { group.leave() }
            if let data = data {
                do {
                        let root = try JSONDecoder().decode(TrailRoot.self, from: data)
                        self.allTrails = root.trails
                        print("trails loaded: \(self.allTrails.count)")
                    
                } catch { print("error decoding trails: \(error)")}
            }
        }.resume()
        
        group.enter()
        let trailsLocationURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=trail_locations")!
        URLSession.shared.dataTask(with: trailsLocationURL) { data, response , error in defer { group.leave() }
            if let data = data {
                do {
                    let root = try JSONDecoder().decode(TrailLocationRoot.self, from: data)
                    DispatchQueue.main.async {
                        self.allTrailLocations = root.trail_locations
                        print("trails points loaded: \(self.allTrailLocations.count)")
                    }
                } catch { print("error decoding trail location points: \(error)")}
            }
        }.resume()
        
        group.notify(queue: .main) {
            self.processData()
            self.setupTrailsMenu()
        }
    }
    
    // MARK: - Trail Logic
        
    func plotTrail(trailId: String) {
            // remove old overlays
            myMap.removeOverlays(myMap.overlays)
            
            //  filter and sort location points
            let points = allTrailLocations
                .filter { $0.trailId == trailId }
                .sorted { (Int($0.sequenceNo) ?? 0) < (Int($1.sequenceNo) ?? 0) }
            
            //  convert to coordinates
            var coordinates: [CLLocationCoordinate2D] = []
            for point in points {
                if let lat = Double(point.latitude), let lon = Double(point.longitude) {
                    coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                }
            }
            
            // 4. draw Polyline
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            myMap.addOverlay(polyline)
            
                }
    
    func setupTrailsMenu() {
            var menuActions: [UIAction] = []
            
            for trail in allTrails {
                let action = UIAction(title: trail.trailName, image: UIImage(systemName: "figure.walk")) { _ in
                    // pass the trail id to the plot function
                    self.plotTrail(trailId: trail.id)
                }
                menuActions.append(action)
            }
                let clearAction = UIAction(title: "Clear Map", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.myMap.removeOverlays(self.myMap.overlays)
                }
                menuActions.append(clearAction)
            
            let menu = UIMenu(title: "Select a Trail", children: menuActions)
            trailsButton.menu = menu
            trailsButton.showsMenuAsPrimaryAction = true
        }
    
    
    func processData() {
        print("--- STARTING DATA MATCHING ---")
        
        // 1. Map Images for quick lookup
        for img in allImages {
            if plantImageMap[img.recnum] == nil {
                plantImageMap[img.recnum] = img.img_file_name
            }
        }
        
        //  Create Sections Map
        var sectionsMap: [String: BedSection] = [:]
        
        for bed in allBeds {
            // FIX: Using 'bed_id' (Short Code "PW1") to match the plants
            // Ensure this variable name matches your Bed struct (bed_id or bed)
            let cleanID = bed.bed_id.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            // Debug: Print the first few keys to ensure they look like "PW1" not "Pinewood 1"
            if sectionsMap.count < 3 { print("debug - Section Key: '\(cleanID)'") }
            
            sectionsMap[cleanID] = BedSection(bed: bed, plants: [])
        }
        
        // assign Plants
        var matchCount = 0
        for plant in allPlants {
            guard plant.accsta == "C" else { continue }
            
            if let bedString = plant.bed {
                let bedCodes = bedString.components(separatedBy: .whitespaces)
                
                for code in bedCodes {
                    let cleanCode = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                    if cleanCode.isEmpty { continue }
                    
                    if sectionsMap[cleanCode] != nil {
                        sectionsMap[cleanCode]?.plants.append(plant)
                        matchCount += 1
                    }
                }
            }
        }
        
        print("DEBUG: Matched \(matchCount) plants to beds.")
        
        // create final array
        self.tableSections = Array(sectionsMap.values).filter { !$0.plants.isEmpty }
        
        // sort by distance
        if let userLocation = locationManager.location {
            for i in 0..<tableSections.count {
                if let bedLocation = tableSections[i].bed.location {
                    tableSections[i].distanceToUser = userLocation.distance(from: bedLocation)
                }
            }
            self.tableSections.sort { $0.distanceToUser < $1.distanceToUser }
        }
        
        print("FINAL: Created \(self.tableSections.count) sections.")
        
        // 6. reload Table
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }
    
    
    
    // MARK: view related setup
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make this view controller a delegate of the Location Managaer, so that it
        //is able to call functions provided in this view controller.
        locationManager.delegate = self as CLLocationManagerDelegate
        
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Ask the location manager to request authorisation from the user. Note that this
        //only happens once if the user selects the "when in use" option. If the user
        //denies access, then your app will not be provided with details of the user's
        //location.
        locationManager.requestWhenInUseAuthorization()
        
        //Once the user's location is being provided then ask for udpates when the user
        //moves around.
        locationManager.startUpdatingLocation()
        
        //configure the map to show the user's location (with a blue dot).
        myMap.showsUserLocation = true
        myTable.delegate = self
        myTable.dataSource = self
        
        fetchData()
    }
    
    // MARK: - Navigation
    // passes plant data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            // get destination view controller
            if let destinationVC = segue.destination as? DetailsViewController {
                
                // find which row tapped
                if let indexPath = myTable.indexPathForSelectedRow {
                    
                    //get correct plant object
                    let selectedPlant = tableSections[indexPath.section].plants[indexPath.row]
                    destinationVC.plant = selectedPlant
                    // passes image file name if there is one
                    if let imageName = plantImageMap[selectedPlant.recnum] {
                        destinationVC.ImageFileName = imageName
                    
                    }
                
             
                }
            }
        }
        
    }
}
    
    

