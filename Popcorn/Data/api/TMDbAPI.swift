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
    func upcomingMovies(page: Int) -> Single<MovieObjAPI>
}

struct TMDbAPI {
    
    enum Timeout {
        static let short: Double = 30
        static let medium: Double = 60
        static let long: Double = 120
    }
    
    static let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    static let apiVersion: String = "/3"
    static let basePath: String = "https://api.themoviedb.org" + apiVersion
}

extension TMDbAPI: TMDbAPIProtocol {
    
    func upcomingMovies(page: Int) -> Single<MovieObjAPI> {
        return TMDbAPI.Movies.getUpcoming(page: page)
    }
}
