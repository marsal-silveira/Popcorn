//
//  MovieDetailsInteractor.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailsInteractorProtocol {

    var movie: Observable<Movie> { get }
}

class MovieDetailsInteractor: BaseInteractor {

    private var _movie: BehaviorRelay<Movie>
    
    init(movie: Movie) {

        _movie = BehaviorRelay<Movie>(value: movie)
        super.init()
    }
}

extension MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    
    var movie: Observable<Movie> {
        return _movie.asObservable()
    }
}
