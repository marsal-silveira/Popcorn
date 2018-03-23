//
//  MovieDetailsViewController.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import Kingfisher

class MovieDetailsViewController: BaseViewController {
    
    // ************************************************
    // MARK: @IBOutlets
    // ************************************************
    
    @IBOutlet fileprivate weak var loadignIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var backdropImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    @IBOutlet fileprivate weak var ratingValueLabel: UILabel!
    @IBOutlet fileprivate weak var releaseDateLabel: UILabel!
    @IBOutlet fileprivate weak var releaseDateValueLabel: UILabel!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var genreValueLabel: UILabel!
    @IBOutlet fileprivate weak var overviewLabel: UILabel!
    
    // ************************************************
    // MARK: Properties
    // ************************************************

    private var _presenter: MovieDetailsPresenterProtocol {
        return basePresenter as! MovieDetailsPresenterProtocol
    }

    fileprivate var _disposeBag = DisposeBag()

    // ************************************************
    // MARK: UIViewController Init | Lifecycle
    // ************************************************
    
    init(presenter: BasePresenterProtocol) {
        super.init(presenter: presenter, nibName: Nibs.movieDetailsViewController.name)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ************************************************
    // MARK: Setup
    // ************************************************
    
    override func bind() {
        super.bind()

        _presenter.movie
            .bind { [weak self] (movie) in
                self?.loadData(movie)
            }
            .disposed(by: _disposeBag)
    }
    
    override func applyLayout() {
        super.applyLayout()
        
        self.title = Strings.movieDetailsTitle()
        
        ratingLabel.text = Strings.movieDetailsRating()
        releaseDateLabel.text = Strings.movieDetailsReleaseDate()
        genreLabel.text = Strings.movieDetailsGenre()
    }

    //*************************************************
    // MARK: - Data
    //*************************************************
    
    private func loadData(_ movie: MovieDetailsVO) {

        titleLabel.text = movie.title
        ratingValueLabel.text = movie.rating
        releaseDateValueLabel.text = movie.releaseDate
        genreValueLabel.text = movie.genre
        overviewLabel.text = movie.overview
        
        self.downloadBackdrop(movie: movie)
    }
    
    private func updateBackdropImage(_ image: UIImage) {
        
        self.loadignIndicator.stopAnimating()
        self.loadignIndicator.isHidden = true
        self.backdropImage.image = image
    }
    
    private func downloadBackdrop(movie: MovieDetailsVO) {
        
        if let picturePath = movie.backdropPath, let pictureURL = URL(string: picturePath) {
            ImageDownloader.default.downloadImage(with: pictureURL, completionHandler: { [weak self] (image, error, _, _) in
                self?.updateBackdropImage(image ?? #imageLiteral(resourceName: "img_placeholder"))
            })
        } else {
            self.updateBackdropImage(#imageLiteral(resourceName: "img_placeholder"))
        }
    }
}
