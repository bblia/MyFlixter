//
//  MovieCell.swift
//  MyFlixter
//
//  Created by Francisco  Delgado on 3/4/17.
//  Copyright © 2017 Francisco  Delgado. All rights reserved.
//

import UIKit

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

        // Configure the view for the selected state
    }

}
