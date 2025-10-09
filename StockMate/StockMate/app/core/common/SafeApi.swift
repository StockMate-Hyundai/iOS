//
//  SafeApi.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

func httpCodeToMessage(_ code: Int?) -> String {
    guard let code = code else { return "알 수 없는 오류가 발생했어요." }
    switch code {
    case 400: return "요청 형식을 다시 확인해주세요."
    case 401: return "로그인이 필요해요. 다시 로그인해주세요."
    case 403: return "접근 권한이 없어요."
    case 404: return "요청하신 정보를 찾을 수 없어요."
    case 408: return "요청 시간이 초과되었어요. 다시 시도해주세요."
    case 409: return "이미 존재하거나 충돌이 발생했어요."
    case 422: return "입력값을 다시 확인해주세요."
    case 429: return "요청이 많아요. 잠시 후 다시 시도해주세요."
    case 500: return "서버 내부 오류가 발생했어요."
    case 502: return "게이트웨이 오류가 발생했어요."
    case 503: return "현재 서버가 점검 중이에요. 잠시 후 다시 시도해주세요."
    case 504: return "서버 응답 시간이 초과되었어요."
    case 500...599: return "서버 오류가 발생했어요. 잠시 후 다시 시도해주세요."
    default: return "문제가 발생했어요. 잠시 후 다시 시도해주세요."
    }
}

@discardableResult
func safeApi<T: Decodable>(_ request: DataRequest, decodeTo: T.Type) async -> AppResult<T> {
    do {
        let response = try await request.serializingDecodable(T.self).response
        if let status = response.response?.statusCode {
            if (200..<300).contains(status), let value = response.value {
                return .success(value)
            } else {
                // 서버가 에러 body에 ApiResponse.message 를 넣어주는 경우 파싱 시도
                if let data = response.data,
                   let serverErr = try? JSONDecoder().decode(ApiResponse<T>.self, from: data),
                   !serverErr.message.isEmpty {
                    return .failure(AppError(code: status, message: serverErr.message, underlying: nil))
                }
                return .failure(AppError(code: status, message: httpCodeToMessage(status), underlying: nil))
            }
        } else {
            return .failure(AppError(code: nil, message: "응답이 유효하지 않습니다.", underlying: nil))
        }
    } catch let afError as AFError {
        // URLError 기반 메시지 분기 (UnknownHost / Timeout 등)
        if let urlErr = afError.underlyingError as? URLError {
            switch urlErr.code {
            case .notConnectedToInternet: return .failure(AppError(code: nil, message: "인터넷 연결을 확인해주세요.", underlying: afError))
            case .timedOut: return .failure(AppError(code: nil, message: "응답이 지연되고 있어요. 잠시 후 다시 시도해주세요.", underlying: afError))
            default: return .failure(AppError(code: nil, message: afError.errorDescription ?? "네트워크 오류가 발생했어요.", underlying: afError))
            }
        }
        return .failure(AppError(code: nil, message: afError.errorDescription ?? "네트워크 오류가 발생했어요.", underlying: afError))
    } catch {
        return .failure(AppError(code: nil, message: "알 수 없는 오류가 발생했어요.", underlying: error))
    }
}

