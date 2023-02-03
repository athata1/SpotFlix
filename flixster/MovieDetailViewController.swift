//
//  MovieDetailViewController.swift
//  flixster
//
//  Created by Akhil Thata on 1/27/23.
//

import UIKit
import Nuke

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    @IBOutlet weak var movieAvgVotes: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    
    var movie:Movie? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            if let backdrop = movie.backdrop_path {
                let image = URL(string:Movie.backdropBaseURLSTring + backdrop)!
                Nuke.loadImage(with: image, into: movieImage);
            }
            self.title = movie.original_title;
            moviePopularity.text = String(movie.popularity) + " Popularity"
            movieDescription.text = movie.overview;
            
            movieAvgVotes.text = String(movie.vote_average) + " Average Votes"
            movieVotes.text = String(movie.vote_count) + " Votes";
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recommendedSegue") {
            let detailViewController = segue.destination as? MovieListViewController;
            
            if let movie = movie {
                detailViewController?.recommendationTitle = movie.original_title
                detailViewController?.recommendationID = movie.id
                detailViewController?.title = "Similar Movies to " + movie.original_title
            }
        }
    }
}
