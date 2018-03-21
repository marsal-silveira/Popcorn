//
//  CoinRepository.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func upcoming(page: Int) -> Single<Movie>
}

class UserRepository: BaseRepository {

    fileprivate let _TMDbAPI: TMDbAPIProtocol

    init(tMDbAPI: TMDbAPIProtocol) {
        _TMDbAPI = tMDbAPI
    }
}

extension UserRepository: UserRepositoryProtocol {

    func upcoming(page: Int) -> Single<Movie> {

        return _TMDbAPI.upcomingMovies(page: page)
            .flatMap({ (movieObjAPI) -> Single<Movie> in

                guard let movie = Movie.map(movieObjAPI: movieObjAPI) else {
                    return Single.error(PopcornError.error(description: "TODO:"))
                }
                return Single.just(movie)
            })
    }
}
