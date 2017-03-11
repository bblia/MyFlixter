//
//  MoviesViewController.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/2/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies:[NSDictionary]?
    var category:String!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.fetchMovies(movieCategory: category, successCallBack: { (movies) in
            self.movies = movies["results"]! as? [NSDictionary] ?? nil
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) in
            print(error ?? "error")
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = Movie(movies![indexPath.row])
        
        cell.setFields(movie)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nowPlaying = movies {
            return nowPlaying.count
        }else{
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = Movie(movies![indexPath!.row])
        
        let detailViewController = segue.destination as! DetailsMovieViewController
        detailViewController.movie = movie
        detailViewController.lowResImage = cell.movieImageView.image
    }
    
}

