//
//  Movie.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/8/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit
import Foundation
class Movie: NSObject {
    var title:String?
    var overView:String? 
    var moviePosterPath:String?
    var rating:Double?
    
    static let highResURL = "https://image.tmdb.org/t/p/original"
    
    init(_ dictionary:NSDictionary){
        self.title = dictionary["title"] as? String
        self.overView = dictionary["overview"] as? String
        self.moviePosterPath = dictionary["poster_path"] as? String
        self.rating = dictionary["vote_average"] as? Double
    }
    
    //request movie array
    class func fetchMovies(movieCategory: String,successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        let apiKey = "ab19882283669e4716d0b7bf2c30f35e"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieCategory)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                successCallBack(dataDictionary)
            }
        }
        task.resume()
    }

    
}
