//
//  MoviesViewController.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/2/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var nowPlaying:[NSDictionary]?
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?region=US&page=1&language=en-US&api_key=ab19882283669e4716d0b7bf2c30f35e")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "UNKOWN ERROR")
            } else {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    self.nowPlaying = responseDictionary["results"]! as? [NSDictionary] ?? nil
                    self.tableView.reloadData()
                }
            }
        })
        
        dataTask.resume()
    
    
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = nowPlaying![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.overViewLabel.text = movie["overview"] as? String
        cell.overViewLabel.sizeToFit()
        let posterPath = movie["poster_path"] as? String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseUrl + posterPath!)
        
        cell.movieImageView.setImageWith(imageURL as! URL)
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

