//
//  GenreResultAPI.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import ObjectMapper

class GenresResultAPI: Mappable {
    
    private(set) var genres: [GenreResultAPI]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        genres <- map["genres"]
    }
}

class GenreResultAPI: Mappable {
    
    private(set) var id: Int?
    private(set) var name: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
