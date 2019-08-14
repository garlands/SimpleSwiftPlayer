//
//  album.swift
//  SimpleSwiftPlayer
//
//  Created by Masahiro Tamamura on 2018/08/10.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import Foundation
import MediaPlayer

class Album  {
    var artist: String
    var title: String
    var artwork : MPMediaItemArtwork?
    var albums_number : Int
    var tracks_number : Int
    var propertyName : String?
    var artworkImage: UIImage?
    var artworkLoaded = false
    
    init(title: String, artist: String, artworkImage : UIImage) {
        self.title = title
        self.artist = artist
        self.albums_number = 0
        self.tracks_number = 0
        self.artworkImage = artworkImage
    }
}
