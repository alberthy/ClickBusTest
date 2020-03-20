//
//  DetailMovieViewController.swift
//  ClickBusTest
//
//  Created by Albert Oliveira on 20/03/20.
//  Copyright © 2020 Albert Oliveira. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    var movie = Movie()
    var movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchDetail()
    }
    
    func fetchDetail(){
    
        movieService.getDetailByMovieId(id: movie.id!).responseData { (response) in
            
            let decoder = JSONDecoder()
                
            let responseSuccess: Swift.Result<MovieDetail, Error> = decoder.decodeResponse(from: response)
            
            let responseData = try! responseSuccess.get()
            
            self.bindView(detailMovie: responseData)
            
        }
        
    }
    
    func bindView(detailMovie: MovieDetail){
          
        backdropImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(detailMovie.backdrop!)"),
                                  placeholderImage: UIImage(named: "place_holder.png"))
        
        titleMovie.text = movie.title
        genre.text = movie.genresDescription()
        releaseDate.text = "Lançamento: \(movie.releaseDateBr())"
        overview.text = movie.overview
        
        budget.text = "Orçamento: \(detailMovie.budget!.description)"
        origin.text = "Origem: \(detailMovie.origin!)"
        popularity.text = "Popularidade: \(detailMovie.popularity!.description)"
        runtime.text = "Execuções: \(detailMovie.runtime!.description)"
        status.text = "Status: \(detailMovie.status!)"
        tags.text = "Tags: \(detailMovie.tags!)"
           
    }
    
   
    
}
