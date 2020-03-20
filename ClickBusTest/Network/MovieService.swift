//
//  MovieService.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import Foundation
import Alamofire

class MovieService {
    
    let path: String = Bundle.main.path(forResource: "moviedb", ofType: "plist")!
    let connection: NSDictionary
    
    var headers: HTTPHeaders
    var api: String
    var apiKey: String
    
    init() {
        connection = NSDictionary(contentsOfFile: path)!
        headers = [
            "Content-Type": connection.object(forKey: "CONTENT_TYPE") as! String
        ]
        api = connection.object(forKey: "API") as! String
        apiKey = connection.object(forKey: "API_KEY") as! String
    }
    
    /*
     * Retorna a lista de filmes populares
     */
    func getPopularMovies(page: Int) -> DataRequest {
       return AF.request("\(api)/movie/popular?page=\(page)&api_key=\(apiKey)", method: .get, headers: headers)
    }
    
    /*
     * Retorna o detalhamento de filme selecionado
     */
    func getDetailByMovieId(id: Int) -> DataRequest {
       return AF.request("\(api)/movie/\(id)?api_key=\(apiKey)", method: .get, headers: headers)
    }
    
    /*
     * Retorna a listagem dos filmes de acordo com o filme consultado.
     */
    func searchMoviesByText(text: String) -> DataRequest {
       return AF.request("\(api)/search/movie?query=\(text)&api_key=\(apiKey)", method: .get, headers: headers)
    }
}
