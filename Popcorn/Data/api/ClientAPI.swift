//
//  ClientAPI.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import Moya
import Result

class ClientAPI<T: TargetType> {
    
    lazy var provider = MoyaProvider<T>(
        endpointClosure: { (target) -> Endpoint<T> in
            return Endpoint<T>(
                url: "\(target.baseURL)\(target.path)",
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        },
        plugins: [
            NetworkActivityPlugin { (change, _) in UIApplication.shared.isNetworkActivityIndicatorVisible = change == .began },
            NetworkLoggerPlugin(verbose: true)
        ]
    )
}
