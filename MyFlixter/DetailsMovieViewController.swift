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
        moviePoster.setImageWith(URL(string: Movie.highResURL+movie.moviePosterPath!)!, placeholderImage: lowResImage)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
