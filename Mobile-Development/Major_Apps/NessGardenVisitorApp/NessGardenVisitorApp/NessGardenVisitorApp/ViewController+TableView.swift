//
//  ViewController+TableView.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    //MARK: tableview setup
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections called, returning \(tableSections.count)")
        return tableSections.count
        
    }
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection \(section), returning \(tableSections[section].plants.count)")
        return tableSections[section].plants.count
    }
    
    
    // give each section a title (bed + distance)
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bedName = tableSections[section].bed.name
        let distance = Int(tableSections[section].distanceToUser)
        // if distance is too large just show name
        if distance > 10000000 { return bedName }
        return "\(bedName) (\(distance)m)"
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cast custom plant cell class
        guard let cell = table.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? PlantCellTableViewCell else {
            return UITableViewCell()
        }
        
        // get specific plant
        let plant = tableSections[indexPath.section].plants[indexPath.row]
        
        // configure content
        var displayImage = UIImage(systemName: "leaf")
        //check if image is already saved in memory
        if let cached = imageCache[plant.recnum] {
            displayImage = cached
        } else if let imageName = plantImageMap[plant.recnum] {
            let urlString = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness_thumbnails/\(imageName)"
            // logic if image exists , starts background download
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let downloadedImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            //adds to cache
                            self.imageCache[plant.recnum] = downloadedImage
                            // updates cell if it is visible on screen
                            if let updateCell = table.cellForRow(at: indexPath) as? PlantCellTableViewCell {
                                updateCell.plantImageView.image = downloadedImage
                            }
                        }
                        
                    }
                }
            }
        }
        cell.configure(plant: plant, image: displayImage)
        return cell
    }
    
    
    
}
