//
//  MovieDetailViewController.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 24/12/20.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    var movieTitle: String?
    var releaseDate: String?
    var rating: Float?
    var overview: String?
    var poster: String?
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var urlString: String = ""
    private var isTouched: Int = 0
    private var isexist: Int = 0
    
    var movie: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitleLabel.text = movieTitle
        movieReleaseDate.text = releaseDate
        overviewLabel.text = overview
        overviewLabel.numberOfLines = 0
        [overviewLabel .sizeToFit()]
        ratingLabel.text = "\(String(describing: rating!))/10"
        
        urlString = "https://image.tmdb.org/t/p/w300" + poster!
        
        guard let posterImageURL = URL(string: urlString) else{
            self.movieImageView.image = UIImage(named: "never")
            return
        }
        
        self.movieImageView.image = nil
        
        getImageDataFrom(url: posterImageURL)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("viewWIllAppear")
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
        
        for x in 0..<movie.count {
            if movieTitle == movie[x].value(forKey: "movieTitle") as? String{
                favoriteButton.setImage(UIImage(named: "heart-3.png"), for: .normal)
                isTouched = 1
            }
        }
        
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "https://www.youtube.com/results?search_query=" + (movieTitle?.replacingOccurrences(of: " ", with: "+"))!) as! URL)
    }
    @IBAction func doFavoriteMovie(_ sender: Any) {
        
        if isTouched == 0 {
            favoriteButton.setImage(UIImage(named: "heart-3.png"), for: .normal)
            isTouched = 1
            for x in 0..<movie.count {
                if movieTitle == movie[x].value(forKey: "movieTitle") as? String{
                    isexist = 1
                }
            }
            if isexist == 0 {
                CoreDataService().save(movieTitle: movieTitle!, releaseDate: releaseDate!, overview: overview!, rating: rating!, posterImage: poster!)
            }
        }
        else if isTouched == 1{
            favoriteButton.setImage(UIImage(named: "heart-2.png"), for: .normal)
            isTouched = 0
            
            for x in 0..<movie.count {
                if movieTitle == movie[x].value(forKey: "movieTitle") as? String{
                    isexist = 0
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    managedContext.delete(movie[x])
                    
                    do{
                        try managedContext.save()
                    }catch{
                        print("Cancel Delete")
                    }
                    
                }
            }
            
        }
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
}
