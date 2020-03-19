//
//  Movie.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import Foundation

class Movie: Decodable {
    
    var title: String?
    var overview: String?
    var releaseDate: String?
    var note: Double?
    var genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case releaseDate = "release_date"
        case note = "vote_average"
        case genreIds = "genre_ids"
    }
    
}
