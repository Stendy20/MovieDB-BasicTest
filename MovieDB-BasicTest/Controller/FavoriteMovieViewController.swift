//
//  FavoriteMovieViewController.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 24/12/20.
//

import UIKit
import CoreData

class FavoriteMovieViewController: UIViewController {
    
    @IBOutlet weak var FavoriteTableView: UITableView!
    private var viewModel = MovieViewModel()
    
    var movie: [NSManagedObject] = []
    
    var movieTitle: String?
    var releaseDate: String?
    var rating: Float?
    var overview: String?
    var poster: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPopularMoviesData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        
        //3
        do {
            movie = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadPopularMoviesData(){
        print("Masuk")
        self.FavoriteTableView.dataSource = self
        self.FavoriteTableView.delegate = self
        self.FavoriteTableView.reloadData()
        
    }
}



extension FavoriteMovieViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection Section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movies = movie[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! FavoriteMovieTableViewCell
        
        var urlString: String = ""
        
        cell.movieTitleLabel.text = movies.value(forKeyPath: "movieTitle") as? String
        cell.releaseDataLabel.text = movies.value(forKeyPath: "movieReleaseDate") as? String
        cell.overviewLabel.text = movies.value(forKeyPath: "movieOverview") as? String
        
        let poster = movies.value(forKeyPath: "posterMovie") as! String
        
        urlString = "https://image.tmdb.org/t/p/w300" + poster
        
        let posterImageURL = URL(string: urlString)!
        
        cell.movieImageview.image = nil
        
        URLSession.shared.dataTask(with: posterImageURL) { (data, response, error) in
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
                    cell.movieImageview.image = image
                }
            }
        }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FavoriteTableView.deselectRow(at: indexPath, animated: true)
        
        takeData(indexPath)
        
        performSegue(withIdentifier: "FavMovietoDetailMovie", sender: self)
    }
    
    func takeData(_ indexPath: IndexPath){
        movieTitle = movie[indexPath.row].value(forKeyPath: "movieTitle") as? String
        rating = movie[indexPath.row].value(forKeyPath: "movieRating") as? Float
        releaseDate = movie[indexPath.row].value(forKeyPath: "movieReleaseDate") as? String
        overview = movie[indexPath.row].value(forKeyPath: "movieOverview") as? String
        poster = movie[indexPath.row].value(forKeyPath: "posterMovie") as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavMovietoDetailMovie" {
            let vc = segue.destination as! MovieDetailViewController
            
            vc.movieTitle = movieTitle
            vc.overview = overview
            vc.rating = rating
            vc.releaseDate = releaseDate
            vc.poster = poster

        }
        
    }
    
}
