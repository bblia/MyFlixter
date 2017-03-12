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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var movies:[NSDictionary]?
    var category:String!
    @IBOutlet weak var tableView: UITableView!
    var listrefreshControl = UIRefreshControl()
    var gridrefreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listrefreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        gridrefreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)

        if #available(iOS 10.0, *){
            tableView.refreshControl = listrefreshControl
            myCollectionView.refreshControl = gridrefreshControl
        }else{
            tableView.insertSubview(listrefreshControl, at: 0)
            myCollectionView.insertSubview(gridrefreshControl, at: 0)
        }
        
        
        
        
        if mySegmentControl.selectedSegmentIndex == 0 {
            myCollectionView.isHidden = true
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.fetchMovies(movieCategory: category, successCallBack: { (movies) in
            self.movies = movies["results"]! as? [NSDictionary] ?? nil
            self.tableView.reloadData()
            self.myCollectionView.reloadData()
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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        Movie.fetchMovies(movieCategory: category, successCallBack: { (movies) in
            self.movies = movies["results"]! as? [NSDictionary] ?? nil
            self.tableView.reloadData()
            self.myCollectionView.reloadData()
            refreshControl.endRefreshing()
        }) { (error) in
            print(error ?? "error")
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nowPlaying = movies {
            return nowPlaying.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let nowPlaying = movies {
            return nowPlaying.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MovieCollectionCell
        let movie = Movie(movies![indexPath.row])
        
        cell.moviePoster.setImageWith(URL(string: "https://image.tmdb.org/t/p/w342"+movie.moviePosterPath!)!)
        
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if sender is MovieCell {
            let cell = sender as! MovieCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = Movie(movies![indexPath!.row])
            let detailViewController = segue.destination as! DetailsMovieViewController
            detailViewController.movie = movie
            detailViewController.lowResImage = cell.movieImageView.image
        }else{
            let cell = sender as! MovieCollectionCell
            let indexPath = myCollectionView.indexPath(for: cell)
            let movie = Movie(movies![indexPath!.row])
            let detailViewController = segue.destination as! DetailsMovieViewController
            detailViewController.movie = movie
            detailViewController.lowResImage = cell.moviePoster.image
        }
    }
    
    @IBAction func displayChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            myCollectionView.isHidden = true
            break
        case 1:
            tableView.isHidden = true
            myCollectionView.isHidden = false
            break
        default:
            break
        }
    }
    
}

