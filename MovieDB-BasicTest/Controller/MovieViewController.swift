//
//  ViewController.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import UIKit

class MovieViewController: UIViewController {
    
    var transparetView = UIView()
    var tableView = UITableView()
    var apiService = ApiService()
    private var viewModel = MovieViewModel()
    
    
    let height: CGFloat = 250
    var settingArray = ["Popular", "UpComing", "Top Rated", "Now Playing"]
    
    var movieTitle: String?
    var releaseDate: String?
    var rating: Float?
    var overview: String?
    var poster: String?
    
    @IBOutlet weak var tableViewMovie: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPopularMoviesData()
        tableViewMovie.delegate = self
        tableViewMovie.dataSource = self

        
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenufromBottomTableView.self, forCellReuseIdentifier: "CELL")
        
    }
    
    func loadPopularMoviesData(){
        viewModel.fetchMoviesData(url: "https://api.themoviedb.org/3/movie/popular?api_key=21a23258a15db192d7cf3d701f792db6&language=en-US&page=1") { [weak self] in
            self?.tableViewMovie.dataSource = self
            self?.tableViewMovie.reloadData()
        }
    }
    
    func loadUpComingMoviesData(){
        viewModel.fetchMoviesData(url: "https://api.themoviedb.org/3/movie/upcoming?api_key=21a23258a15db192d7cf3d701f792db6&language=en-US&page=1") { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewMovie.dataSource = self
                self?.tableViewMovie.reloadData()
                self?.tableViewMovie.beginUpdates()
                self?.tableViewMovie.endUpdates()
            }
        }
    }
    
    func loadTopRatedMoviesData(){
        viewModel.fetchMoviesData(url: "https://api.themoviedb.org/3/movie/top_rated?api_key=21a23258a15db192d7cf3d701f792db6&language=en-US&page=1") { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewMovie.dataSource = self
                self?.tableViewMovie.reloadData()
                self?.tableViewMovie.beginUpdates()
                self?.tableViewMovie.endUpdates()
            }
        }
    }
    
        
    func loadNowPlayingMoviesData(){
        viewModel.fetchMoviesData(url: "https://api.themoviedb.org/3/movie/now_playing?api_key=21a23258a15db192d7cf3d701f792db6&language=en-US&page=2") { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewMovie.dataSource = self
                self?.tableViewMovie.reloadData()
                self?.tableViewMovie.beginUpdates()
                self?.tableViewMovie.endUpdates()
            }
        }
    }
    
    @IBAction func doOpenFavoritePage(sender: Any) {
        self.performSegue(withIdentifier: "MovietoFavoriteMovie", sender: nil)
    }
    
    @IBAction func doCategoriesMenu(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        transparetView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transparetView.frame = self.view.frame
        window?.addSubview(transparetView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doCategoriesMenuTransparent))
        transparetView.addGestureRecognizer(tapGesture)
        
        transparetView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
            self.transparetView.alpha = 0.8
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - (self.height-30), width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func doCategoriesMenuTransparent(){
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
            self.transparetView.alpha = 0.0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            
        }, completion: nil)
    }
    
    
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === tableViewMovie {
            return viewModel.numberOfRowsInSection(section: section)
        }
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === tableViewMovie{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
            let movie = viewModel.cellForRowAt(indexPath: indexPath)

            cell.setCellWithValuesOf(movie)
            return cell
        }
        guard let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? MenufromBottomTableView else {fatalError("Unable to deque Cell")}
        Cell.label.text = settingArray[indexPath.row]
        return Cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsIn Section: Int) -> Int{
        if tableView === tableViewMovie {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === tableViewMovie {
            return 196
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === tableViewMovie {
            tableViewMovie.deselectRow(at: indexPath, animated: true)
            
            let movie = viewModel.cellForRowAt(indexPath: indexPath)
            takeValue(movie)
            
            performSegue(withIdentifier: "MoviestoMoviesDetail", sender: self)
        }
        else if tableView === tableView {
            switch indexPath.row {
            case 0:
                print(settingArray[indexPath.row])
                loadPopularMoviesData()
            case 1:
                print(settingArray[indexPath.row])
                loadUpComingMoviesData()
            case 2:
                print(settingArray[indexPath.row])
                loadTopRatedMoviesData()
            case 3:
                print(settingArray[indexPath.row])
                loadNowPlayingMoviesData()
            default:
                print(settingArray[indexPath.row])
            }
        }
    }
    
    func takeValue(_ movie: Movie){
        movieTitle = movie.title
        rating = movie.rating
        releaseDate = MovieTableViewCell().convertDateFormater(movie.year)
        overview = movie.overview
        poster = movie.posterImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "MovietoFavoriteMovie" {
            let vc = segue.destination as! MovieDetailViewController
            vc.movieTitle = movieTitle
            vc.overview = overview
            vc.rating = rating
            vc.releaseDate = releaseDate
            vc.poster = poster
        }
        
    }
}
