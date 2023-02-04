//
//  UpcomingViewController.swift
//  flixster
//
//  Created by Akhil Thata on 2/2/23.
//

import UIKit

class UpcomingViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // Get the track that corresponds to the table view row
        let movie = movies[indexPath.row]

        // Configure the cell with it's associated track
        cell.configure(with: movie)

        // return the cell for display in the table view
        return cell
    }

    var movies: [Movie] = [Movie]()
    var count: Int = 0;
    var index: Int = 1;
    @IBOutlet weak var tableView: UITableView!
    
    func makeRequest(curr currDate: Date, next nextDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let apiKey:String? = String(describing: String(describing: ProcessInfo.processInfo.environment["movieDBKey"]).split(separator: "\"")[1]);
        
        if let key = apiKey {
            let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(String(describing: index))&release_date.gte=\(dateFormatter.string(from: currDate))&release_date.lte=\(dateFormatter.string(from: nextDate))&with_watch_monetization_types=flatrate&region=US")!
            
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
                
                // The `JSONSerialization.jsonObject(with: data)` method is a "throwing" function (meaning it can throw an error) so we wrap it in a `do` `catch`
                // We cast the resultant returned object to a dictionary with a `String` key, `Any` value pair.
                do {
                    
                    let decoder = JSONDecoder()
                    
                    let response = try decoder.decode(MoviesResponse.self, from: data)
                    
                    var movies = response.results
                    DispatchQueue.main.async { [self] in
                        for i in stride(from: movies.count - 1, to: -1, by: -1) {
                            let currMovie:Movie = movies[i];
                            let date:Date? = dateFormatter.date(from: currMovie.release_date)
                            if let date = date {
                                if (date < currDate || date > nextDate) {
                                    movies.remove(at: i)
                                    print(currMovie.original_title)
                                }
                            }
                            else {
                                movies.remove(at: i);
                            }
                        }
                        
                        
                        self?.movies += movies
                        self?.count += movies.count;
                        self?.index += 1;
                        if (self!.count > 20) {
                            self?.tableView.reloadData()
                        }
                        else {
                            self?.makeRequest(curr: currDate, next: nextDate)
                        }
                    }
                } catch {
                    print("❌ Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate:Date = Date()
        let nextDate:Date = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
    
            
        // Use the URL to instantiate a request
        makeRequest(curr: currentDate, next: nextDate)
        
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
