//
//  MovieCell.swift
//  flixster
//
//  Created by Akhil Thata on 1/26/23.
//

import UIKit
import Nuke

class MovieCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDesctiption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 30.0/255.0, green: 215.0/255.0, blue: 96.0/255.0, alpha: 0.75)
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configure(with movie: Movie) {
        movieTitle.text = movie.original_title;
        movieDesctiption.text = movie.overview;
        if let path = movie.poster_path {
            let image = URL(string:Movie.posterBaseURLString + path)!
            Nuke.loadImage(with: image, into: moviePoster);
        }
    }
}
