//
//  track.swift
//  SimpleSwiftAudioPlayer
//
//  Created by Masahiro Tamamura on 2018/08/10.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import Foundation
import MediaPlayer

class Track  {
    var artist: String
    var albumtitle: String
    var title: String
    var artworkImage: UIImage?
    var artworkLoaded = false
    var duration : Int
    var audioFileURL : URL?
    
    
    init(albumtitle: String, artist: String, title: String, artworkImage: UIImage, duration: Int, audioFileURL: URL) {
        self.albumtitle = albumtitle
        self.artist = artist
        self.title = title
        self.artworkImage = artworkImage
        self.duration = duration
        self.audioFileURL = audioFileURL
    }
}
