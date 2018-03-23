//
//  MovieCell.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var posterImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var detailsLabel: UILabel!
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    @IBOutlet fileprivate weak var loadignIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = #imageLiteral(resourceName: "img_placeholder")
        loadignIndicator.isHidden = false
        loadignIndicator.startAnimating()
    }
    
    func setup(movie: Movie) {

        titleLabel.text = movie.title
        detailsLabel.text = movie.releaseDate
        ratingLabel.text = "★ \(movie.rating)"
        
        self.downloadPoster(movie: movie)
    }
    
    private func updatePosterImage(_ image: UIImage) {
        
        loadignIndicator.isHidden = true
        loadignIndicator.stopAnimating()
        posterImageView.image = image
    }
    
    private func downloadPoster(movie: Movie) {
        
        if let picturePath = movie.posterPath, let pictureURL = URL(string: "http://image.tmdb.org/t/p/w300\(picturePath)") {
            
            ImageDownloader.default.downloadImage(with: pictureURL, completionHandler: { [weak self] (image, error, _, _) in
                self?.updatePosterImage(image ?? #imageLiteral(resourceName: "img_placeholder"))
            })
        } else {
            self.updatePosterImage(#imageLiteral(resourceName: "img_placeholder"))
        }
    }
}
