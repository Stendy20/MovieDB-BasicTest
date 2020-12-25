//
//  MovieViewModel.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import Foundation

class MovieViewModel{
    private var apiService = ApiService()
    private var popularMovis = [Movie]()
    
    func fetchMoviesData(url: String, completion: @escaping () -> ()){
        apiService.getPopularMoviesData(url: url){ [weak self] (result) in
            switch result{
            case .success(let listOf):
                self?.popularMovis = listOf.movies
                completion()
            case .failure(let error):
                print("Error Processing Json Data: \(error)")
            }
            
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int{
        if popularMovis.count != 0 {
            return popularMovis.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie{
        return popularMovis[indexPath.row]
    }
}
