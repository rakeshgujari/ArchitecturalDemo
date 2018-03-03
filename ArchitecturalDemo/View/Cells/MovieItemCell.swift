//
//  MovieItemCell.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class MovieItemCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
