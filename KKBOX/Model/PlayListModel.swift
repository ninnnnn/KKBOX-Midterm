//
//  PlayListModel.swift
//  KKBOX
//
//  Created by Ninn on 2020/1/17.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

class PlayListModel: Codable {
    let tracks: Tracks
}

class Tracks: Codable {
    var data: [PlayList]
}

class PlayList: Codable {
    let album: Album
    let name: String
    var isLike: Bool?
}

class Album: Codable {
    let name: String
    let images: [Images]
}

class Images: Codable {
    let url: String
}
