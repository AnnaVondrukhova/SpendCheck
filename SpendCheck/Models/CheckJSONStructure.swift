//
//  CheckJSONStructure.swift
//  SpendCheck
//
//  Created by Anya on 02.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

struct JSONCheck: Decodable {
    let document: Document
}

struct Document: Decodable {
    let receipt: Receipt
}

struct Receipt: Decodable {
    let user: String?
    let totalSum: Int
    let dateTime: String
    let userInn: String
    let items: [Item]
}

struct Item: Decodable {
    let quantity: Double
    let price: Int
    let sum: Int
    let name: String
}
