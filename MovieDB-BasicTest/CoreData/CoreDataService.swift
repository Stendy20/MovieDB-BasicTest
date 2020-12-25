//
//  CoreDataService.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 24/12/20.
//

import UIKit
import CoreData

class CoreDataService {
    
    open var movie: [NSManagedObject] = []
    
    func save(movieTitle: String, releaseDate: String, overview: String, rating: Float, posterImage: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext)!
        
        let movies = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movies.setValue(movieTitle, forKeyPath: "movieTitle")
        movies.setValue(releaseDate, forKeyPath: "movieReleaseDate")
        movies.setValue(overview, forKeyPath: "movieOverview")
        movies.setValue(rating, forKeyPath: "movieRating")
        movies.setValue(posterImage, forKeyPath: "posterMovie")
        
        // 4
        do {
            try managedContext.save()
            movie.append(movies)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch(){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        
        do {
            movie = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
}
