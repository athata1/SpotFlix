//
//  Movies.swift
//  flixster
//
//  Created by Anderson David on 1/20/23.
//

import Foundation

struct MoviesResponse: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var id:Int
    var original_title: String
    var overview: String
    
    var poster_path: String? // when loading image with Nuke, make sure you convert to url by prepending base url
    static var posterBaseURLString: String = "https://image.tmdb.org/t/p/w185"
    static var backdropBaseURLSTring: String = "https://image.tmdb.org/t/p/w500"
    var backdrop_path:String?
    var popularity: Double
    var vote_average: Double
    var vote_count: Int
}

struct MoviesRecommendedResponse: Decodable {
    var results: [Movie]
    var pages: Int
    var total_pages:Int
}


