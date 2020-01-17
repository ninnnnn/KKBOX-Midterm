//
//  SongListProvider.swift
//  KKBOX
//
//  Created by Ninn on 2020/1/17.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum PlayListRequest: Request {
    case playlists
    
    var headers: [String : String] {
        switch self {
        case .playlists:
            return [HTTPHeaderField.auth.rawValue: "Bearer lShNnIBJAxzkZRPMpAH1Fg=="]
        }
    }
    
    var body: Data? {
        switch self {
        case .playlists:
//            let boundary = "Boundary+\(arc4random())\(arc4random())"
//            let parameters = ["grant_type": "client_credentials",
//                              "client_id": "e6ae932608877b47ab7a3de8970981b0",
//                              "client_secret": "647bc4d8ec23351317d93cba4727c8c4"]
            let data: Data = "grant_type=client_credentials&client_id=e6ae932608877b47ab7a3de8970981b0&client_secret=647bc4d8ec23351317d93cba4727c8c4".data(using: .utf8)!
            return nil
        }
    }
    
    var method: String {
        switch self {
        case .playlists:
            return HTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .playlists:
            return "/DZrC8m29ciOFY2JAm3?territory=TW&limit=20"
        }
    }
}

class PlayListProvider {
    func getHitsPlayList(completion: @escaping (Result<PlayListModel>) -> Void) {
        let decoder = JSONDecoder()
        HTTPClient.shared.request(PlayListRequest.playlists, completion: { (result) in
            switch result {
            case .success(let data):
                do {
                    let result = try decoder.decode(PlayListModel.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

extension Data{
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
