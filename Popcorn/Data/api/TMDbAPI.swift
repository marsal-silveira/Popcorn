//
//  TMDbAPI.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

protocol TMDbAPIProtocol {
    // Movies
    func upcomingMovies(page: Int) -> Single<UpcomingMoviesResultAPI>
    
    // Genres
    func genres() -> Single<[GenreResultAPI]>
}

struct TMDbAPI {
    
    enum Timeout {
        static let short: Double = 30
        static let medium: Double = 60
        static let long: Double = 120
    }
    
    // API constants
    static let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    static let apiVersion: String = "/3"
    static let apiBasePath: String = "https://api.themoviedb.org" + apiVersion
    
    // Images constants (poster and backdrop paths)
    private static let imageBasePath: String = "https://image.tmdb.org/t/p"
    static let posterBasePath: String = imageBasePath + "/w300"
    static let backdropBasePath: String = imageBasePath + "/w780"
}

extension TMDbAPI: TMDbAPIProtocol {
    
    // ************************************************
    // MARK: Movies
    // ************************************************
    
    func upcomingMovies(page: Int) -> Single<UpcomingMoviesResultAPI> {
        return TMDbAPI.Movies.getUpcoming(page: page)
    }
    
    // ************************************************
    // MARK: Genres
    // ************************************************
    
    func genres() -> Single<[GenreResultAPI]> {
        return TMDbAPI.Genres.getGenres()
    }
}
