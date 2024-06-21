//
//  Character.swift
//  BB Quotes
//
//  Created by ulixe on 23/04/24.
//

import Foundation

struct Character: Decodable {

    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let portrayedBy: String
}
