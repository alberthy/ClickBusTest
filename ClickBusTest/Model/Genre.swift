//
//  Genre.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import Foundation

struct GenreData: Decodable {
    var genres: [Genre]
}

struct Genre : Decodable {
    var id: Int
    var name: String
}

func loadJson(filename fileName: String) -> [Genre]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(GenreData.self, from: data)
            return jsonData.genres
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
