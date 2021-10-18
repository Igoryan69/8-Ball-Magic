//
//  ReceivedData.swift
//  8 Ball Magic
//
//  Created by Игорь Антонченко on 18.10.2021.
//

import Foundation

struct ReceivedData: Codable {
    let magic : Magic
}

struct Magic: Codable {
    let answer: String
    let type: String
}
