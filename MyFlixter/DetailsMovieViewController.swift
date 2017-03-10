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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        movieTitle.text = movie.title
        overViewLabel.text = movie.overView
        overViewLabel.sizeToFit()
        
        moviePoster.setImageWith(NSURL(string: Movie.lowResURL+movie.moviePosterPath!)! as URL)
        DispatchQueue.main.async {
            self.moviePoster.setImageWith(NSURL(string: Movie.highResURL+self.movie.moviePosterPath!)! as URL)

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

