//
//  MovieListViewController.swift
//  flixster
//
//  Created by Anderson David on 1/20/23.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource {
    
    var movies: [Movie] = [Movie]()
    var recommendationID:Int? = nil;
    var recommendationTitle:String? = nil;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let apiKey:String? = String(describing: String(describing: ProcessInfo.processInfo.environment["movieDBKey"]).split(separator: "\"")[1]);
        
        if let key = apiKey {
            
            var url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)")!
            
            if let recommendationID = recommendationID {
                url = URL(string: "https://api.themoviedb.org/3/movie/\(String(describing: recommendationID))/recommendations?api_key=\(key)&language=en-US&page=1")!
            }
            
            // Use the URL to instantiate a request
            let request = URLRequest(url: url)
            
            // Create a URLSession using a shared instance and call its dataTask method
            // The data task method attempts to retrieve the contents of a URL based on the specified URL.
            // When finished, it calls it's completion handler (closure) passing in optional values for data (the data we want to fetch), response (info about the response like status code) and error (if the request was unsuccessful)
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
                
                // The `JSONSerialization.jsonObject(with: data)` method is a "throwing" function (meaning it can throw an error) so we wrap it in a `do` `catch`
                // We cast the resultant returned object to a dictionary with a `String` key, `Any` value pair.
                do {
                    
                    let decoder = JSONDecoder()
                    
                    let response = try decoder.decode(MoviesResponse.self, from: data)
                    
                    let movies = response.results
                    DispatchQueue.main.async {
                        
                        self?.movies = movies
                        
                        self?.tableView.reloadData()
                    }
                    for movie in movies {
                        print(movie.original_title)
                    }
                } catch {
                    print("❌ Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }
        
        tableView.dataSource = self;
        tableView.separatorColor = UIColor.systemGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {

            // Deselect the row at the corresponding index path
            tableView.deselectRow(at: indexPath, animated: true)
        }
       
    }
    

    // TODO: Pt 1 - Add table view data source methods
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // Get the track that corresponds to the table view row
        let movie = movies[indexPath.row]

        // Configure the cell with it's associated track
        cell.configure(with: movie)

        // return the cell for display in the table view
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Pt 1 - Pass the selected track to the detail view controller
        if let cell = sender as? UITableViewCell,
           // Get the index path of the cell from the table view
           let indexPath = tableView.indexPath(for: cell),
           // Get the detail view controller
           let detailViewController = segue.destination as? MovieDetailViewController {

            // Use the index path to get the associated track
            let movie = movies[indexPath.row]

            // Set the track on the detail view controller
            detailViewController.movie = movie
        }
        recommendationID = nil;
        recommendationTitle = nil;

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
