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
    var nowPlaying:[NSDictionary]?
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let apiKey = "ab19882283669e4716d0b7bf2c30f35e"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                self.nowPlaying = dataDictionary["results"]! as? [NSDictionary] ?? nil
                self.tableView.reloadData()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()

        
    
    
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = Movie(dictionary: nowPlaying![indexPath.row])
        
        cell.titleLabel.text = movie.title
        cell.overViewLabel.text = movie.overView
        cell.movieImageView.setImageWith(movie.moviePosterUrl!)
        cell.overViewLabel.sizeToFit()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nowPlaying = nowPlaying {
            return nowPlaying.count
        }else{
            return 0
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

