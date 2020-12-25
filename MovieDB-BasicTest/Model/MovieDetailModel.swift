//
//  MovieDetailModel.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 24/12/20.
//

import Foundation

class MovieDetailModel{
    var movieTitle: String?
    var releaseDate: String?
    var rating: Float?
    var overview: String?
    var poster: String?
    
    init(_ movieTitle: String, _ releaseDate: String, _ rating: Float, _ overview: String, _ poster: String) {
        self.movieTitle = movieTitle
        self.releaseDate = releaseDate
        self.rating = rating
        self.overview = overview
        self.poster = poster
    }
}
