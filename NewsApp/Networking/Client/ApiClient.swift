//
//  ApiClient.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

public enum APIError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case somethingWrong
    case initial
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiError:
            return NSLocalizedString("Error from api", comment: "api")
        case .invalidEndpoint:
            return NSLocalizedString("Endpoint is invalid", comment: "endpoint")
        case .invalidResponse:
            return NSLocalizedString("Could not reach", comment: "response")
        case .noData:
            return NSLocalizedString("There is no data", comment: "nodata")
        case .decodeError:
            return NSLocalizedString("Error in decoding", comment: "decode")
        case .somethingWrong:
            return NSLocalizedString("Something went wrong", comment: "something wrong")
        case .initial:
            return NSLocalizedString("", comment: "")
        }
    }
}

protocol ApiClient {
}

extension ApiClient {
    
    func responseHandler<T : Codable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> (Result<T, APIError>)? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return .failure(APIError.invalidResponse)
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode >= 200 && response.statusCode < 300 {
            guard let data = data else {
                print("\(TAG): empty data")
                return .failure(APIError.noData)
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return .success(result)
            } else {
                print("\(TAG): failed to parse data")
                return .failure(APIError.decodeError)
            }
        } else {
            print("\(TAG): Network Error - Code: \(response.statusCode)")
            return .failure(APIError.invalidResponse)
        }
    }
}
