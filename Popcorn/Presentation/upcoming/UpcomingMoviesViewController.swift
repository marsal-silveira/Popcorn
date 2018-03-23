//
//  UpcomingMoviesViewController.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class UpcomingMoviesViewController: BaseViewController {
    
    // ************************************************
    // MARK: Properties
    // ************************************************

    private var _presenter: UpcomingMoviesPresenterProtocol {
        return basePresenter as! UpcomingMoviesPresenterProtocol
    }

    fileprivate var _movies = [Movie]()
    
    fileprivate var _disposeBag = DisposeBag()
    
    // ************************************************
    // MARK: UI Components
    // ************************************************
    
    fileprivate lazy var _refreshControl: UIRefreshControl = {

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UpcomingMoviesViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.customBlue
        refreshControl.alpha = 0.75

        return refreshControl
    }()
    
    private lazy var _collectionView: UICollectionView = {
        
        // create collection and its layout
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: CollectionViewGridLayout())

        // set delegate and dataSource
        collectionView.dataSource = self
        collectionView.delegate = self

        // background
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        
        // RefreshControll (Pull to Refresh)
        collectionView.refreshControl = _refreshControl

        // register cells
        collectionView.register(MovieCell.self)
        
        return collectionView
    }()

    // ************************************************
    // MARK: UIViewController Lifecycle
    // ************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupOnLoad()
    }

    // ************************************************
    // MARK: Setup
    // ************************************************
    
    override func bind() {
        super.bind()

        _presenter.movies
            .bind(onNext: { [weak self] (movies) in self?.showMovies(movies) })
            .disposed(by: _disposeBag)
    }
    
    private func setupOnLoad() {
        
        self.title = Strings.upcomingMoviesTitle()
        
        self.addBackgroundImage(#imageLiteral(resourceName: "bg_upcoming"))
        self.addCollectionView()
        self.loadData(reset: true)
    }
    
    private func addCollectionView() {
        self.view.addSubview(_collectionView)
        constrain(view, _collectionView) { (container, collectionView) in
            collectionView.edges == container.edges
        }
    }
    
    //*************************************************
    // MARK: - Pull To Refresh
    //*************************************************

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.loadData(reset: true)
    }

    //*************************************************
    // MARK: - Data
    //*************************************************
    
    private func loadData(reset: Bool = false) {
        _presenter.fetchMovies(reset: reset)
    }
    
    private func showMovies(_ movies: [Movie]) {
        _movies.removeAll()
        _movies.append(contentsOf: movies)
        
        print("->> count \(_movies.count)")
        _movies.forEach { (movie) in
            print("->> [\(movie.id)]\(movie.title)")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?._refreshControl.endRefreshing()
            self?._collectionView.reloadData()
        }
    }
}

// ************************************************
// MARK: - UICollectionViewDataSource
// ************************************************

extension UpcomingMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieCell
        cell.setup(movie: _movies[indexPath.row])
        
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }

        return cell
    }
}

// ************************************************
// MARK: - UICollectionViewDelegate
// ************************************************

extension UpcomingMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._presenter.didSelectMovie(strongSelf._movies[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        print("indexPath -> \(indexPath.row)")
        if indexPath.row == _movies.count-1 {

//            print(">>>>>>>>>>>>>> indexPath -> \(indexPath.row)")
            _presenter.fetchMovies(reset: false)
//            _movies.append(contentsOf: Photo.allPhotos())
//            DispatchQueue.main.async {
//                collectionView.reloadData()
//            }
        }
    }
}