//
//  Movie.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/8/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var title:String?
    var overView:String? 
    var moviePosterUrl:URL?
    
    init(dictionary:NSDictionary){
        self.title = dictionary["title"] as? String
        self.overView = dictionary["overview"] as? String
        let posterPath = dictionary["poster_path"] as? String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        self.moviePosterUrl = NSURL(string: baseUrl + posterPath!) as? URL
    }
    //factory method
    class func fetchMovies(successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        let apiKey = "ab19882283669e4716d0b7bf2c30f35e"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                //print(dataDictionary)
                successCallBack(dataDictionary)
            }
        }
        task.resume()
    }

    
}
