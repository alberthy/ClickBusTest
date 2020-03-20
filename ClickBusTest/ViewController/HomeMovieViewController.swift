//
//  HomeMovieViewController.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class HomeMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let backGroundImageView = UIImageView()
    var movies: [Movie]! = []
    var movieService = MovieService()
    var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.fetchData(currentPage: currentPage)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let movieSearch = searchBar.text, movieSearch != "" else {
            Alert(self).show("Alerta!", message: "Para realizar consulta é necessário informar o nome do filme!")
            return
        }
        
        self.searchMoviesByText(text: movieSearch)
        
    }
    
    func searchMoviesByText(text: String) {
        
        print("search in \(text)")
        
        movieService.searchMoviesByText(text: text).responseData { (response) in
            
            let decoder = JSONDecoder()
                
            let responseSuccess: Swift.Result<MovieResponse, Error> = decoder.decodeResponse(from: response)
            
            let responseData = try! responseSuccess.get()
            
             self.movies = responseData.movies
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func fetchData(currentPage: Int){
        
        movieService.getPopularMovies(page: currentPage).responseData { (response) in
            
            let decoder = JSONDecoder()
                
            let responseSuccess: Swift.Result<MovieResponse, Error> = decoder.decodeResponse(from: response)
            
            let responseData = try! responseSuccess.get()
            
            self.movies = self.movies + responseData.movies!
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let mvCell = tableView.dequeueReusableCell(withIdentifier: "MovieViewCell", for: indexPath) as! MovieViewCell
       
        mvCell.movie = self.movies[indexPath.row]
        
        // Ajuste para paginação. Como cada página só está retornando 20 registros, utilizei
        // o incremente por página e não pelos 30 registros.
        // Quando chega o final chamo uma nova page.
        if indexPath.row == (self.movies.count - 1){
            currentPage += 1
            fetchData(currentPage: currentPage)
        }
        
        return mvCell
    }
    
    // event for view movie detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailSegue" {
            if let detailMovieTableView = segue.destination as? DetailMovieViewController {
                if let index = self.tableView.indexPathForSelectedRow?.row {
                    detailMovieTableView.movie = self.movies[index]
                }
            }
        }
        
    }

}

class MovieViewCell: UITableViewCell {
    
    @IBOutlet weak var trumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var avgNote: UILabel!
    
    var movie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        title.text = movie.title
        genres.text = movie.genresDescription()
        avgNote.text = String(movie.note ?? 0.0)
        releaseDate.text = "Lançamento: \(movie.releaseDateBr())"
        trumbnail.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster ?? "")"), placeholderImage: UIImage(named: "place_holder.png"))
    }
    
}

extension JSONDecoder {
    
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Swift.Result<T, Error> {
        
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            return .failure(response.error!)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print(error)
            return .failure(error)
        }
    }
}


