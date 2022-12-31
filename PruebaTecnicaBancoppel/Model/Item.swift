//
//  Item.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 26/12/22.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let item = try? newJSONDecoder().decode(Item.self, from: jsonData)

import Foundation

// MARK: - Item
struct Item: Codable {
    var products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, productDescription: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id, title
        case productDescription = "description"
        case price, discountPercentage, rating, stock, brand, category, thumbnail, images
    }
}
