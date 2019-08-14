//
//  Albums.swift
//  SimpleSwiftAudioPlayer
//
//  Created by Masahiro Tamamura on 2018/08/12.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import Foundation
import MediaPlayer

class Albums {
    init() {
        
    }
    
    func musicLibraryAlbums() -> Array<Album> {
        //        print("artist \(self.artist) title\(self.title)")
        var albums : Array<Album> = Array()
        let query = MPMediaQuery.albums()
        //        query.addFilterPredicate(MPMediaPropertyPredicate(value: "Album Title", forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo))
        
        guard let albumlists = query.collections else {
            print("albumlists is nil")
            return albums
        }
        for albumlist : MPMediaItemCollection in albumlists {
            if let item : MPMediaItem = albumlist.representativeItem {
            let artist = item.value(forProperty: MPMediaItemPropertyArtist)
            let title = item.value(forProperty: MPMediaItemPropertyAlbumTitle)
            print("titale \(String(describing: title)) artist \(String(describing: artist))")
            let artwork_image : UIImage
            if let artwork = item.value(forProperty:MPMediaItemPropertyArtwork) {
                artwork_image = (artwork as AnyObject).image(at:CGSize(width:80, height:80))!
            }else{
                artwork_image = UIImage(named: "no_image.png")!
            }
            let album : Album = Album.init(title: title as! String, artist: artist as! String, artworkImage: artwork_image )
            albums.append(album)
            }
        }
        return albums
    }
}

