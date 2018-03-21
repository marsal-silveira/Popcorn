//
//  MovieAPI.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension TMDbAPI {
    
    enum Movies: TMDbTarget {
        case upcoming(page: Int)
        
        // TargetType
        var path: String {
            switch self {
            case .upcoming(let page):
                return "/movie/upcoming?api_key=\(TMDbAPI.apiKey)&page=\(page)"
            }
        }
        
        var method: Moya.Method {
            switch self {
            default:
                return .get
            }
        }
        
        // Endpoints
        static func getUpcoming(page: Int) -> Single<MovieObjAPI> {
            
            return ClientAPI<TMDbAPI.Movies>().provider.rx
                .request(.upcoming(page: page))
                .timeout(TMDbAPI.Timeout.short, scheduler: MainScheduler.instance)
                .flatMap({ (response) -> Single<Moya.Response> in
                    
                    // process response code
                    switch response.statusCode {
                    case 200..<299:
                        return Single.just(response)
                            //                case 401:
                        //                    return Single.error(PopcornError.Login.invalidCredentials)
                    default:
                        return Single.error(PopcornError.error(description: Strings.errorDefault()))
                    }
                })
                .mapObject(MovieObjAPI.self)
                .catchError({ (error) -> Single<MovieObjAPI> in return Single.error(APIUtil.translateError(error)) })
        }
    }
}
