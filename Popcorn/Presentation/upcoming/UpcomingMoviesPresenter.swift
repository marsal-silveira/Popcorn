//
//  UpcomingMoviesPresenter.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UpcomingMoviesPresenterProtocol: BasePresenterProtocol {

    var router: UpcomingMoviesRouterProtocol? { get set }
    var movies: Observable<[Movie]> { get }
    
    func fetchMovies(reset: Bool)
    
    func didSelectMovie(_ movie: Movie)
}

class UpcomingMoviesPresenter: BasePresenter {
    
    private let _interactor: UpcomingMoviesInteractorProtocol
    private let _disposeBag = DisposeBag()
    
    private var _movies = BehaviorRelay<[Movie]>(value: [])

    private weak var _router: UpcomingMoviesRouterProtocol?
    public var router: UpcomingMoviesRouterProtocol? {
        get { return _router }
        set { _router = newValue }
    }
    
    init(interactor: UpcomingMoviesInteractorProtocol) {
    
        _interactor = interactor
        
        super.init()
        bind()
    }

    private func bind() {

        _interactor.movies
            .bind {[weak self] (response) in
                guard let strongSelf = self else { return }

                switch response {

                case .loading:
                    strongSelf._viewState.accept(.loading(LoadingViewModel(text: Strings.placeholderLoading())))

                case .success(let movies):
                    strongSelf._viewState.accept(.normal)
                    strongSelf._movies.accept(movies)

                case .failure(let error):
                    let placeholderViewModel = ErrorViewModel(text: Strings.errorDefault(), details: error.localizedDescription)
                    strongSelf._viewState.accept(.error(placeholderViewModel))

                default:
                    break
                }
            }
            .disposed(by: _disposeBag)
    }
}

extension UpcomingMoviesPresenter: UpcomingMoviesPresenterProtocol {
    
    var movies: Observable<[Movie]> {
        return _movies.asObservable()
    }

    func fetchMovies(reset: Bool = false) {
        _interactor.fetchMovies(reset: reset)
    }
    
    func didSelectMovie(_ movie: Movie) {
        _router?.showDetails(for: movie)
    }
}
