//
//  dataModel.swift
//  Research Papers
//
//  Created by Kian Palas on 06/12/2025.
//

import Foundation

nonisolated
struct techReport: Decodable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    let abstract: String?
    let pdf: URL?
    let comment: String?
    let lastModified: String
}

nonisolated
struct technicalReports: Decodable {
let techreports2: [techReport]
}
