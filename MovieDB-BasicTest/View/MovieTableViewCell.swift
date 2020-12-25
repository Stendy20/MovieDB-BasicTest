//
//  MovieTableViewCell.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell{
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDataLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var urlString: String = ""
    
    func setCellWithValuesOf(_ movie: Movie){
        updateUI(title: movie.title, releaseData: movie.year, overView: movie.overview, poster: movie.posterImage, rating: movie.rating)
    }
    
    private func updateUI(title: String?, releaseData: String?, overView: String?, poster: String?, rating: Float?){
        self.movieTitleLabel.text = title
        self.releaseDataLabel.text = convertDateFormater(releaseData)
        self.overviewLabel.text = overView
        
        guard let posterString = poster else {return}
        
        urlString = "https://image.tmdb.org/t/p/w300" + posterString

        guard let posterImageURL = URL(string: urlString) else{
            self.movieImageView.image = UIImage(named: "never")
            return
        }
        
        self.movieImageView.image = nil
        
        getImageDataFrom(url: posterImageURL)
    }
    
    private func getImageDataFrom(url: URL){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.movieImageView.image = image
                }
            }
        }.resume()
    }
    
    func convertDateFormater(_ date: String?) -> String{
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date{
            if let newDate = dateFormatter.date(from: originalDate){
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
