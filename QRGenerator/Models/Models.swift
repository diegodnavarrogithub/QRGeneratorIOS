//
//  Models.swift
//  QRGenerator
//
//  Created by Diego Dominguez on 30/08/24.
//

import Foundation

// Define the request model
struct QRRequest: Codable {
    let destination_url: String
}

// Define the response model
struct QRResponse: Codable {
    let qr_image: String
}
