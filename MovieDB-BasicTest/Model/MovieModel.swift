//
//  MovieModel.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import Foundation

struct MoviesData: Decodable{
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey{
        case movies = "results"
    }
}

struct Movie: Decodable{
    let title: String?
    let year: String?
    let posterImage: String?
    let overview: String?
    let rating: Float?
    
    private enum CodingKeys: String, CodingKey{
        case overview
        case title = "original_title"
        case year = "release_date"
        case posterImage = "poster_path"
        case rating = "vote_average"
        
    }
}
