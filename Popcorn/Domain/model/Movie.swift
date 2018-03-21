//
//  Movie.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

class Movie: NSObject, NSCoding {
    
    private(set) var login: String
    private(set) var password: String
    
    private(set) var accessToken: String
    
    init(login: String, password: String, accessToken: String) {
        
        self.login = login
        self.password = password
        self.accessToken = accessToken
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let login = aDecoder.decodeObject(forKey: "login") as? String,
              let password = aDecoder.decodeObject(forKey: "password") as? String,
              let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String else {
                
            return nil
        }
        self.init(login: login, password: password, accessToken: accessToken)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey: "login")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(accessToken, forKey: "accessToken")
    }
}

extension Movie {

    static func map(movieObjAPI: MovieObjAPI) -> Movie? {

//        guard let login = MovieObjAPI.login,
//              let password = MovieObjAPI.password,
//              let accessToken = MovieObjAPI.accessToken else {
//
//            return nil
//        }
        return Movie(login: "", password: "", accessToken: "")
    }
}
