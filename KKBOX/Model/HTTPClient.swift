//
//  HTTPClient.swift
//  KKBOX
//
//  Created by Ninn on 2020/1/17.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum HTTPClientError: Error {
    case decodeDataFail
    case clientError(Data)
    case serverError
    case unexpectedError
}

enum HTTPMethod: String {
    case GET
    case POST
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case auth = "Authorization"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
    case formData = "application/x-www-form-urlencod"
}

protocol Request {
    var headers: [String: String] { get }
    var body: Data? { get }
    var method: String { get }
    var endPoint: String { get }
}

extension Request {
    func makeRequest() -> URLRequest {
        let urlString = "https://api.kkbox.com/v1.1/new-hits-playlists" + endPoint
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.httpMethod = method
        return request
    }
}

class HTTPClient {
    
    static let shared = HTTPClient()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private init() { }
    
    func request(
        _ stRequest: Request,
        completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.delegateQueue.maxConcurrentOperationCount = 10
        URLSession.shared.dataTask(
            with: stRequest.makeRequest(),
            completionHandler: { (data, response, error) in
                guard error == nil else {
                    return completion(Result.failure(error!))
                }
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 200..<300:
                    completion(Result.success(data!))
                case 400..<500:
                    completion(Result.failure(HTTPClientError.clientError(data!)))
                case 500..<600:
                    completion(Result.failure(HTTPClientError.serverError))
                default: return
                    completion(Result.failure(HTTPClientError.unexpectedError))
                }
        }).resume()
    }
}
