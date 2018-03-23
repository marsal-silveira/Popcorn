//
//  UpcomingMovies.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

class UpcomingMovies {
    
    private(set) var page: Int
    private(set) var totalPages: Int
    private(set) var totalMovies: Int
    private(set) var movies: [Movie]
    
    init(page: Int, totalPages: Int, totalMovies: Int, movies: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.totalMovies = totalMovies
        self.movies = movies
    }
}

extension UpcomingMovies {
 
    static func map(upcomingMoviesResult: UpcomingMoviesResultAPI) -> UpcomingMovies? {
        
        guard let page = upcomingMoviesResult.page,
              let totalPages = upcomingMoviesResult.totalPages,
              let totalMovies = upcomingMoviesResult.totalMovies,
              let movies = upcomingMoviesResult.movies else {
            return nil
        }
        let mo = movies.map { (movieResult) -> Movie in
            return Movie.map(movieResult: movieResult)!
        }
        return UpcomingMovies(page: page, totalPages: totalPages, totalMovies: totalMovies, movies: mo)
    }
}
