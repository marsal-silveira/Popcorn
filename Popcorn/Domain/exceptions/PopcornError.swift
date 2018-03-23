//
//  PopcornError.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

protocol PopcornErrorProtocol: LocalizedError, CustomStringConvertible {
    
}

extension PopcornErrorProtocol {
    
    var description: String {
        return errorDescription ?? ""
    }
}
    
enum PopcornError: PopcornErrorProtocol {

    case network
    case timeout
    case parsingJSON
    case error(description: String)

    var errorDescription: String? {

        switch self {
        case .network:
            return Strings.errorNetwork()
        case .timeout:
            return Strings.errorTimeout()
        case .parsingJSON:
            return Strings.errorParsingJson()
        case .error(let description):
            return description
        }
    }
}
