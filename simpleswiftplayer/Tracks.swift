//
//  Tracks.swift
//  SimpleSwiftAudioPlayer
//
//  Created by Masahiro Tamamura on 2018/08/12.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import Foundation
import MediaPlayer

class Tracks {
    init() {
        
    }
    
    func musicLibraryTracks_album(albumTitle : String) -> Array<Track> {
        //        print("artist \(self.artist) title\(self.title)")
        var tracks : Array<Track> = Array()
        let query = MPMediaQuery.songs()
        
        let tracklists = query.collections
        
        for tracklist : MPMediaItemCollection in tracklists! {
            
            let item : MPMediaItem = tracklist.representativeItem!
            let cloud : Int = item.value(forProperty:MPMediaItemPropertyIsCloudItem) as! Int
            let isCloud : Bool = (cloud != 0)
            if isCloud == true {
                continue
            }
            let albumtitle : String = item.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String

            print("cmp  \(albumTitle) - \(albumtitle)")
            if albumtitle == albumTitle {
                let audioFileURL : URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
                if let _ : URL = audioFileURL {
                    let artist = item.value(forProperty: MPMediaItemPropertyArtist)
                    let title = item.value(forProperty: MPMediaItemPropertyTitle)
                    let duration_nsnumber : NSNumber = item.value(forProperty: MPMediaItemPropertyPlaybackDuration) as! NSNumber
                    let duration = duration_nsnumber.intValue
                    
                    print("artist \(String(describing: artist))")
                    print("titale \(String(describing: title))")
                    print("duration \(duration)")
                    
                    let artwork_image : UIImage
                    if let artwork = item.value(forProperty:MPMediaItemPropertyArtwork) {
                        artwork_image = (artwork as AnyObject).image(at:CGSize(width:80, height:80))!
                    }else{
                        artwork_image = UIImage(named: "no_image.png")!
                    }
                    //            let artwork = item.value(forProperty:MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                    //            MPMediaItemArtwork.init(image: UIImage (data: (self.musicModel?.musicimg)!)!)] as [String : Any]
                    let track : Track = Track.init(albumtitle: albumtitle , artist: artist as! String, title: title as! String, artworkImage: artwork_image , duration: duration as! Int, audioFileURL: audioFileURL )
                    tracks.append(track)
                }
            }

        }
        print(tracks.count)
        return tracks
    }
}

