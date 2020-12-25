//
//  FavoriteMovieTableViewCell.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 24/12/20.
//

import UIKit
import CoreData

class FavoriteMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageview: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDataLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var urlString: String = ""
    
    let coreData = CoreDataService()
    func setCellWithValuesOf(_ indexPath: IndexPath){
        
        let movie = coreData.movie[indexPath.row]
        
        updateUI(title: (movie.value(forKey: "movieTitle") as? String), releaseData: movie.value(forKey: "movieReleaseDate") as? String, overView: movie.value(forKey: "movieOverview") as? String, poster: movie.value(forKey: "posterMovie") as? String, rating: movie.value(forKey: "movieRating") as? Float)
    }
    
    private func updateUI(title: String?, releaseData: String?, overView: String?, poster: String?, rating: Float?){
        self.movieTitleLabel.text = title
        self.releaseDataLabel.text = convertDateFormater(releaseData)
        self.overviewLabel.text = overView
        
        guard let posterString = poster else {return}
        
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else{
            self.movieImageview.image = UIImage(named: "never")
            return
        }
        
        self.movieImageview.image = nil
        
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
                    self.movieImageview.image = image
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

