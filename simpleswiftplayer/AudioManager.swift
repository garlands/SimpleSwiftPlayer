//
//  AudioManager.swift
//  SimpleSwiftAudioPlayer
//
//  Created by Masahiro Tamamura on 2018/08/12.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


enum play_kind : Int  {
    case select_play = 0
    case prepare = 1
    case current_play = 2
}

enum AudioState {
    case none
    case stop
    case play
    case pause
    case terminate
}

enum IntState : Int {
    case play = 1
    case stop = 2
    case forword = 3
    case rewind = 4
    case pause = 5
}

protocol AudioManagerDelegate {
    func audioStatus(state : AudioState)
    func updateMusicTitleAvmgr(title: String)
    
}

extension AudioManagerDelegate {
    func audioStatus(state : Int) {
        print("extension audioStatus")
    }
}

class AudioManager: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer!
    var delegate : AudioManagerDelegate?
    
    var album_title : String?
    var albumArtworkImage : UIImage?
    var album_index : Int = -1
    var tracks : Array<Track>?
    var currentTrackIndex : Int = 0
    var selected_music : Bool = false
    var prepare_music : Bool = false
    
    static let sharedInstance: AudioManager = AudioManager()
    private override init() {
        super.init()
    }
    
    func startSelectMusic(index: Int){
        if let trs : Array<Track> = tracks {
            if index < trs.count {
                currentTrackIndex = index
                startMusic(play_kind: play_kind.select_play)
            }
        }
    }
    
    func startMusic(play_kind: play_kind){
        selected_music = false

        switch play_kind {
        case .current_play:
            if prepare_music == true && audioPlayer != nil {
                prepare_music = true;
                playStartMusic();
            }else{
                if prepareMusic() == true {
                    prepare_music = true;
                    playStartMusic();
                }
            }
        case .prepare:
            if prepareMusic() == true {
                prepare_music = true
            }
        case .select_play:
            if prepareMusic() == true {
                prepare_music = true;
                playStartMusic()
            }
        }
    }
    
    func prepareMusic() -> Bool {
        var ret : Bool = false
        if let trs : Array<Track> = tracks {
            if currentTrackIndex < trs.count {
                let tr : Track = trs[currentTrackIndex]
                if let url : URL = tr.audioFileURL {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer.delegate = self as AVAudioPlayerDelegate
                        audioPlayer.play()
                        delegate?.audioStatus(state: AudioState.play)
                        
                        if tr.title.isEmpty == false {
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("kChangeMusicNotification"), object: nil)
                            
                            guard let delegate = self.delegate else {
                                print("empty delegate")
                                return false
                            }
                            delegate.updateMusicTitleAvmgr(title:tr.title)
                            ret = true
                        }
                        
                    } catch {
                        print("error ");
                    }
                }
            }
        }
        return ret
    }
    
    func playStartMusic() {
        audioPlayer.play()
        changeAudioState(state: AudioState.play)
    }
    
    func pauseMusic() {
        audioPlayer.pause()
        changeAudioState(state: AudioState.stop)
    }
    
    func playMusic(){
        if let audio : AVAudioPlayer = audioPlayer {
            if audio.isPlaying != true {
                audio.play()
                changeAudioState(state: AudioState.play)
            }
        }
    }
    
    func nextMusic() {
        var now_play = false
        if let audio : AVAudioPlayer = audioPlayer {
            now_play = audio.isPlaying
        }

        terminateAudioPlayer()
        
        var count : Int = 0
        if let trs : Array<Track> = tracks {
            for tr : Track in trs {
                if let url : URL = tr.audioFileURL {
                    count = count + 1
                    print(url)
                }
            }
            
            if currentTrackIndex + 1 < count {
                currentTrackIndex = currentTrackIndex + 1
                
                if now_play == true {
                    startMusic(play_kind: play_kind.select_play)
                }else{
                    startMusic(play_kind: play_kind.prepare)
                }
            }else{
                changeAudioState(state: AudioState.stop)
            }
        }
    }
    
    func prevMusic() {
        var now_play = false
        if let audio : AVAudioPlayer = audioPlayer {
            now_play = audio.isPlaying
        }
        if currentTrackIndex > 0 {
             terminateAudioPlayer()
            
            currentTrackIndex = currentTrackIndex - 1
            if now_play == true {
                startMusic(play_kind: play_kind.select_play)
            }else{
                startMusic(play_kind: play_kind.prepare)
            }
        }else{
            pauseMusic()
            audioPlayer.currentTime = 0
            changeAudioState(state: AudioState.stop)
        }
    }
    
    func isPlaying() -> Bool {
        if let audio : AVAudioPlayer = audioPlayer {
            return audio.isPlaying
        }else{
            return false
        }
    }

    func changeAudioState(state: AudioState){
        let nc = NotificationCenter.default
        let userinfo = ["state": state]
        nc.post(name: Notification.Name("kChangeAudioStateNotification"), object: nil, userInfo: userinfo)
        guard let delegate = self.delegate else {
            print("empty delegate")
            return
        }
        delegate.audioStatus(state: state)
    }
    
    func terminateAudioPlayer() {
        if let audio : AVAudioPlayer = audioPlayer {
            audio.stop()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("kChangeAudioStateNotification"), object: nil)
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        print("finish")
        guard let delegate = self.delegate else {
            print("empty delegate")
            return
        }
        delegate.audioStatus(state: AudioState.stop)
        print(IntState.stop.rawValue)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print("error")
        guard let delegate = self.delegate else {
            print("empty delegate")
            return
        }
        delegate.audioStatus(state: AudioState.stop)
    }
    
    func countTracks() -> Int {
        if let tr : Array<Track> = tracks {
            return tr.count
        }
        return 0
    }
    
    func getSelectTitle(index : Int) -> String {
        if let trs : Array<Track> = tracks {
            if index < trs.count {
                let tr : Track = trs[index]
                return tr.title
            }
        }
        return ""
    }
    func getSelectDuringTime(index : Int) -> Int {
        if let trs : Array<Track> = tracks {
            if index < trs.count {
                let tr : Track = trs[index]
                return tr.duration
            }
        }
        return 0
    }
    
    func getCurrentTrackArtworkImage(size : CGSize) -> UIImage? {
        if let artworkImage : UIImage = albumArtworkImage {
            return artworkImage
        }
        return nil
    }
    
    func getCurrentTitleString() -> String? {
        if let trs : Array<Track> = tracks {
            if currentTrackIndex < trs.count {
                let tr : Track = trs[currentTrackIndex]
                return tr.title
            }
        }
        return nil
    }
    
    func getCurrentArtistString() -> String? {
        if let trs : Array<Track> = tracks {
            if currentTrackIndex < trs.count {
                let tr : Track = trs[currentTrackIndex]
                return tr.artist
            }
        }
        return nil
    }
}
