//
//  Service+API.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import Foundation

class ApiService{
    private var dataTask: URLSessionDataTask?
    
    func getPopularMoviesData(url: String, completion: @escaping (Result<MoviesData, Error>)-> Void){
        let popularMoviesURL = url
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("Empty Response")
                return
            }
            print("Response Status code: \(response.statusCode)")
            
            guard let data = data else{
                print("Empty Data")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
//    func getLatestMoviesData(completion: (Result<MoviesData, Error>)-> void){
//        let popularMoviesURL = ""
//    }
}
