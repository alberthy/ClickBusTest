//
//  HomeMovieViewController.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 19/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import UIKit
import Alamofire

class HomeMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let backGroundImageView = UIImageView()
    var movies: [Movie]! = []
    var movieService = MovieService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.applybackground()
        self.fetchData();
    }
    
    func fetchData(){
        
        movieService.getPopularMovies(page: 1).responseData { (response) in
            
            let decoder = JSONDecoder()
                
            let responseSuccess: Swift.Result<MovieResponse, Error> = decoder.decodeResponse(from: response)
            
            let responseData = try! responseSuccess.get()
            
            self.movies = responseData.movies
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mvCell = tableView.dequeueReusableCell(withIdentifier: "MovieViewCell", for: indexPath) as! MovieViewCell
        mvCell.movie = self.movies[indexPath.row]
        return mvCell
    }
    
    func applybackground() {
        
        view.addSubview(backGroundImageView)
        
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backGroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backGroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backGroundImageView.image = UIImage(named: "background")
        
        view.sendSubviewToBack(backGroundImageView)

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
        genres.text = filterGenre(ids: movie.genreIds!)
        avgNote.text = String(movie.note!)
        releaseDate.text = "Lançamento: \(formatDatePtBR(date: movie.releaseDate!))"
        
    }
    
    func filterGenre(ids: [Int]) -> String {
        
        let genresDataBase =  loadJson(filename: "genres")
        
        var genresString: String = ""
        
        var count = 0;

        for id in ids {
            genresDataBase?.forEach({ (g) in
                genresString.append((id == g.id) ? "\(g.name) " : "")
            })
            count = count + 1
        }
        
        return genresString
    
    }
    
    func formatDatePtBR(date: String!) -> String {
        
       let dateFormatter = DateFormatter()
       let createdDate = dateFormatter.date(fromSwapiString: movie.releaseDate!)
       
       let dateFormatterBr = DateFormatter()
       dateFormatterBr.dateFormat = "dd/MM/yyyy"
        
        return dateFormatterBr.string(from: createdDate!)
        
    }
    
    
}



extension DateFormatter {
    
  func date(fromSwapiString dateString: String) -> Date? {
    self.dateFormat = "yyyy-MM-dd"
    self.timeZone = TimeZone(abbreviation: "UTC")
    self.locale = Locale(identifier: "pt_BR")
    return self.date(from: dateString)
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


