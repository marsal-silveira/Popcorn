//
//  TMDbTarget.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya

protocol TMDbTarget: TargetType {
    
}

extension TMDbTarget {

    var baseURL: URL {
        return URL(string: TMDbAPI.basePath)!
    }

    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
}
