//
//  PosterViewController.swift
//  flixster
//
//  Created by Akhil Thata on 2/1/23.
//

import UIKit

class PosterViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCollectionViewCell", for: indexPath) as! PosterCollectionViewCell

            // Use the indexPath.item to index into the albums array to get the corresponding album
            let movie = movies[indexPath.item]

            // Get the artwork image url
            cell.configure(with: movie);

            return cell
    }
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let apiKey:String? = String(describing: String(describing: ProcessInfo.processInfo.environment["movieDBKey"]).split(separator: "\"")[1]);
        
        
        if let key = apiKey {
            // Do any additional setup after loading the view.
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)")!
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                // Handle any errors
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                }
                
                // Make sure we have data
                guard let data = data else {
                    print("❌ Data is nil")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let response = try decoder.decode(MoviesResponse.self, from: data)
                    
                    let movies = response.results
                    DispatchQueue.main.async {
                        
                        self?.movies = movies
                        
                        self?.collectionView.reloadData()
                    }
                    for movie in movies {
                        print(movie.original_title)
                    }
                } catch {
                    print("❌ Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
        
        collectionView.dataSource = self;
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell), let detailViewController = segue.destination as? MovieDetailViewController {
            let movie = movies[indexPath.row];
            
            detailViewController.movie = movie;
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

}
