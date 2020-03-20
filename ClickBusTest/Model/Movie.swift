//
//  Movie.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import Foundation

class Movie: Decodable {
    
    var id: Int?
    var title: String?
    var overview: String?
    var releaseDate: String?
    var note: Double?
    var genreIds: [Int]?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case releaseDate = "release_date"
        case note = "vote_average"
        case genreIds = "genre_ids"
        case poster = "poster_path"
    }
    
    func genresDescription() -> String {
        
        let genresDataBase =  loadJson(filename: "genres")
        
        var genresString: String = ""
        
        for gId in genreIds! {
            genresDataBase?.forEach({ (g) in
                genresString.append((gId == g.id) ? "\(g.name) " : "")
            })
        }
        
        return genresString

    }
    
    func releaseDateBr() -> String {
        
       let dateFormatter = DateFormatter()
       let createdDate = dateFormatter.date(fromSwapiString: releaseDate!)
       
       let dateFormatterBr = DateFormatter()
       dateFormatterBr.dateFormat = "dd/MM/yyyy"
        
        return dateFormatterBr.string(from: createdDate!)
        
    }
    
}

class MovieDetail: Decodable {
    
    var backdrop: String?
    var title: String?
    var genreDescription: String?
    var releaseDate: String?
    var budget: Double?
    var origin: String?
    var popularity: Double?
    var runtime: Int?
    var status: String?
    var tags: String?
    
    var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case backdrop = "backdrop_path"
        case releaseDate = "release_date"
        case budget = "budget"
        case origin = "original_language"
        case popularity = "popularity"
        case runtime = "runtime"
        case status = "status"
        case tags = "tagline"
    }
    
}


// functions util


extension DateFormatter {
    
  func date(fromSwapiString dateString: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "pt_BR")
        return self.date(from: dateString)
  }
    
}
