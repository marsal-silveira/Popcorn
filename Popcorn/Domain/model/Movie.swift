//
//  Movie.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

class Movie: NSObject, NSCoding {
    
    private(set) var id: Int64
    private(set) var title: String
    private(set) var posterPath: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: Date
    private(set) var overview: String
//    private(set) var genres: [Genre]
    
    init(id: Int64, title: String, posterPath: String?, backdropPath: String?, releaseDate: Date, overview: String) {
        
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.overview = overview
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
              let overview = aDecoder.decodeObject(forKey: "overview") as? String,
              let releaseDate = aDecoder.decodeObject(forKey: "releaseDate") as? Date else {
            return nil
        }
        
        let id = aDecoder.decodeInt64(forKey: "id")
        let posterPath = aDecoder.decodeObject(forKey: "posterPath") as? String
        let backdropPath = aDecoder.decodeObject(forKey: "backdropPath") as? String
        self.init(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate, overview: overview)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(posterPath, forKey: "posterPath")
        aCoder.encode(backdropPath, forKey: "backdropPath")
        aCoder.encode(releaseDate, forKey: "releaseDate")
        aCoder.encode(overview, forKey: "overview")
    }
}

extension Movie {

    static func map(movieObjAPI: MovieObjAPI) -> Movie? {
        
        guard let id = movieObjAPI.id,
              let title = movieObjAPI.title,
              let overview = movieObjAPI.overview,
              let releaseDate = movieObjAPI.releaseDate else {
            return nil
        }
        
        let posterPath = movieObjAPI.posterPath
        let backdropPath = movieObjAPI.backdropPath

        return Movie(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate, overview: overview)
    }
}
