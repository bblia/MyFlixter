//
//  MovieCell.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/4/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit
import Foundation

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFields(_ movie: Movie){
        titleLabel.text = movie.title
        overViewLabel.text = movie.overView
        
        let imageRequest = NSURLRequest(url: NSURL(string: "https://image.tmdb.org/t/p/w342"+movie.moviePosterPath!)! as URL)
        
        self.movieImageView.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    self.movieImageView.alpha = 0.0
                    self.movieImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.movieImageView.alpha = 1.0
                    })
                } else {
                    self.movieImageView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
        })
        
        
        
        overViewLabel.sizeToFit()
    }
}


