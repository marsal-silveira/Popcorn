//
//  MovieRepository.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieRepositoryProtocol {

    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> { get }
    func getUpcomingMovies(page: Int)
}

class MovieRepository: BaseRepository {

    fileprivate let _TMDbAPI: TMDbAPIProtocol
    fileprivate var _upcomingMovies = BehaviorRelay<RequestResponse<UpcomingMovies>>(value: .new)
    
    fileprivate var _disposeBag = DisposeBag()

    init(tMDbAPI: TMDbAPIProtocol) {
        _TMDbAPI = tMDbAPI
    }
}

extension MovieRepository: MovieRepositoryProtocol {
    
    var upcomingMovies: Observable<RequestResponse<UpcomingMovies>> {
        return _upcomingMovies.asObservable()
    }

    func getUpcomingMovies(page: Int) {
        
        _upcomingMovies.accept(.loading)
        
        _TMDbAPI.upcomingMovies(page: page)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .success(let upcomingMoviesResult):
                    guard let upcomingMovies = UpcomingMovies.map(upcomingMoviesResult: upcomingMoviesResult) else { fatalError() }
                    strongSelf._upcomingMovies.accept(.success(upcomingMovies))
                    
                case .error(let error):
                    strongSelf._upcomingMovies.accept(.failure(error))
                }
            }
            .disposed(by: _disposeBag)
    }
}
