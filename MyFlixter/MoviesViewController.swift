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
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var movies:[NSDictionary]?
    var category:String!
    @IBOutlet weak var tableView: UITableView!
    var listrefreshControl = UIRefreshControl()
    var gridrefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorLabel.isHidden = true
        
        //refresh controls
        listrefreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        gridrefreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)

        if #available(iOS 10.0, *){
            tableView.refreshControl = listrefreshControl
            myCollectionView.refreshControl = gridrefreshControl
        }else{
            tableView.insertSubview(listrefreshControl, at: 0)
            myCollectionView.insertSubview(gridrefreshControl, at: 0)
        }
        //set grid to hidden upon first load.
        if mySegmentControl.selectedSegmentIndex == 0 {
            myCollectionView.isHidden = true
        }
        //assign datasources and delagates for list and grid views.
        tableView.dataSource = self
        tableView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        //network request.
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.fetchMovies(movieCategory: category, successCallBack: { (movies) in
            self.movies = movies["results"]! as? [NSDictionary] ?? nil
            self.tableView.reloadData()
            self.myCollectionView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) in
            print(error ?? "error")
            self.networkErrorLabel.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    //list set up.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = Movie(movies![indexPath.row])
        cell.selectionStyle = .none
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
    //grid view set up.
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
        
        let imageRequest = NSURLRequest(url: NSURL(string: "https://image.tmdb.org/t/p/w342"+movie.moviePosterPath!)! as URL)
        cell.moviePoster.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    cell.moviePoster.alpha = 0.0
                    cell.moviePoster.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.moviePoster.alpha = 1.0
                    })
                } else {
                    cell.moviePoster.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
        })
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //segue to detailed view
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
    //swith between list and grid view.
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
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        Movie.fetchMovies(movieCategory: category, successCallBack: { (movies) in
            self.movies = movies["results"]! as? [NSDictionary] ?? nil
            self.tableView.reloadData()
            self.myCollectionView.reloadData()
            self.networkErrorLabel.isHidden = true
        }) { (error) in
            self.networkErrorLabel.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        refreshControl.endRefreshing()
    }
    
}

