//
//  ApiClient.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

struct ApiClient {
    static let baseURL = "https://api.stockmate.site/"
    static let shared: Session = {
        let interceptor = AuthInterceptor()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        return Session(configuration: config, interceptor: interceptor, eventMonitors: [])
    }()
}

