//
//  APIUtils.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import Result

extension Data {

    var asJSON: Result<[String: Any], NSError> {
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
                return Result.failure(PopcornError.parsingJSON as NSError)
            }
            return Result.success(JSONDict)
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

enum APIUtil {

    private enum RxSwiftErrorCode {
        static let timeout: Int = 6
    }

    static func translateError(_ error: Swift.Error) -> Swift.Error {

        let extractedError = translateMoyaError(error)
        if extractedError.code == NSURLErrorNotConnectedToInternet || extractedError.code == NSURLErrorNetworkConnectionLost {
            return PopcornError.network
        }
        if extractedError.code == NSURLErrorTimedOut || extractedError.code == RxSwiftErrorCode.timeout {
            return PopcornError.timeout
        }
        return error
    }

    private static func translateMoyaError(_ error: Swift.Error) -> NSError {

        if let moyaError = error as? Moya.MoyaError {
            switch moyaError {
            case .underlying(let error, _):
                return error as NSError
            default:
                return moyaError as NSError
            }
        } else {
            return error as NSError
        }
    }
}
