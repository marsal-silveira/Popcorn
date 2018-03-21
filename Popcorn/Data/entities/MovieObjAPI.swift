//
//  MovieObjAPI.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieObjAPI: Mappable {
    
    private(set) var id: Int64?
    private(set) var title: String?
    private(set) var posterPath: String?
    private(set) var backdropPath: String?
    private(set) var releaseDate: Date?
    private(set) var overview: String?
//    private(set) var genres: [Genre]
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        releaseDate <- map["release_date"]
        overview <- map["overview"]
    }
}
