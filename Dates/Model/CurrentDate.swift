//
//  CurrentDate.swift
//  Dates
//
//  Created by Dirisu on 13/04/2023.
//

import Foundation

struct CurrentDate: Identifiable, Decodable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}

