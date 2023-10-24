//
//  Model.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 19/10/23.
//

import Foundation

struct PreviewAsset: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
    let previewSongURL: URL?
}
