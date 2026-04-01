//
//  dataModel.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 07/12/2025.
//

import Foundation
import CoreLocation

// bed struct from API
struct Bed: Codable {
    let bed_id: String //
    let name: String
    let latitude: String // API returns coordinates as Strings
    let longitude: String
    
    // converts string lat/lon to CLLocation
    var location: CLLocation? {
        guard let lat = Double(latitude), let lon = Double(longitude) else { return nil
        }
        return CLLocation(latitude: lat, longitude: lon)
    }
}

struct Plant: Codable {
    let recnum: String
    let genus: String?
    let species: String?
    let vernacular_name: String?
    let infraspecific_epithet: String?
    let cultivar_name: String?
    let bed: String? // contains multiple beds separated by whitespace
    let accsta: String
    
    let latitude: String?
    let longitude: String?
    let country: String?
    let donor: String?
    
}

struct PlantImage: Codable {
    let recnum: String
    let img_file_name: String 
}

// MARK: - custom table data structure
// holds the data for one section of the table (one Bed)
struct BedSection {
    let bed: Bed
    var plants: [Plant]
    var distanceToUser: Double = Double.greatestFiniteMagnitude // default to far away
}

struct BedRoot: Codable {
    let beds: [Bed]
}

struct PlantRoot: Codable {
    let plants: [Plant]
}

struct ImageRoot: Codable {
    let images: [PlantImage]
}

//MARK: trail model

struct TrailRoot: Codable {
    let trails: [Trail]
}

struct Trail: Codable {
    let id: String
    let trailName: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case trailName = "Trail_Name"
        case description = "Description"
    }
}

struct TrailLocationRoot: Codable {
    let trail_locations: [TrailLocation]
}

struct TrailLocation: Codable {
    let trailId: String
    let latitude: String
    let longitude: String
    let sequenceNo: String
    
    enum CodingKeys: String, CodingKey {
        case trailId = "Trail_ID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case sequenceNo = "Sequence_No"
    }
}
