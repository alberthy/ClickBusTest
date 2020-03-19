//
//  MovieResponse.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import Foundation

class MovieResponse: Decodable {

    var movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

}
