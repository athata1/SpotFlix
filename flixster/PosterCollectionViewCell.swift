//
//  PosterCollectionViewCell.swift
//  flixster
//
//  Created by Akhil Thata on 2/1/23.
//

import UIKit
import Nuke

class PosterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    func configure(with movie: Movie) {
        if let path = movie.poster_path {
            let imageUrl = URL(string: Movie.posterBaseURLString + path)!;
            Nuke.loadImage(with: imageUrl, into: posterImage)
        }
    }
}
