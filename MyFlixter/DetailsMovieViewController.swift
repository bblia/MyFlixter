//
//  DetailsMovieViewController.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/9/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit

class DetailsMovieViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var movie:Movie!
    var lowResImage:UIImage!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        movieTitle.text = movie.title
        overViewLabel.text = movie.overView
        overViewLabel.sizeToFit()
        
        
        let imageRequest = NSURLRequest(url: URL(string: Movie.highResURL+movie.moviePosterPath!)!)
        moviePoster.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: lowResImage,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    self.moviePoster.alpha = 0.0
                    self.moviePoster.image = image
                    UIView.animate(withDuration: 0.80, animations: { () -> Void in
                        self.moviePoster.alpha = 1.0
                    })
                } else {
                    self.moviePoster.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
        })
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
