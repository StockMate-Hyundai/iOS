//
//  ApiClient.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

struct ApiClient {
    static let baseURL = "https://api.stockmate.site/"      // 기본 API 서버 주소
    static let shared: Session = {                          // Alamofire의 Session을 싱글톤 형태로 공유
        
        // 요청 시 토큰 등을 자동으로 처리하기 위한 인터셉터 설정
        let interceptor = AuthInterceptor()
        
        // 네트워크 요청 관련 기본 설정 구성
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        
        // 커스텀 설정과 인터셉터를 적용한 세션 생성
        return Session(configuration: config, interceptor: interceptor, eventMonitors: [])
    }()
}

