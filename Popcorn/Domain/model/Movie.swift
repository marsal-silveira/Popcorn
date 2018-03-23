//
//  Movie.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

class Movie {
    
    private(set) var id: Int64
    private(set) var title: String
    private(set) var posterPath: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: String
    private(set) var overview: String
    private(set) var rating: Double
//    private(set) var genres: [Genre]
    
    init(id: Int64, title: String, posterPath: String?, backdropPath: String?, releaseDate: String, overview: String, rating: Double) {
        
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.rating = rating
    }
}

extension Movie {

    static func map(movieResult: MovieResultAPI) -> Movie? {
        
        guard let id = movieResult.id,
              let title = movieResult.title,
              let overview = movieResult.overview,
              let rating = movieResult.rating,
              let releaseDate = movieResult.releaseDate else {
            return nil
        }
        
        let posterPath = movieResult.posterPath
        let backdropPath = movieResult.backdropPath

        return Movie(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate, overview: overview, rating: rating)
    }
    
    static func mapArray(moviesResult: [MovieResultAPI]) -> [Movie] {
        
        return moviesResult
            .map { map(movieResult: $0) }
            .filter { $0 != nil }
            .map { $0! }
    }
}
