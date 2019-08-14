//
//  MiniPlayerView.swift
//  simpleswiftplayer
//
//  Created by Masahiro Tamamura on 2019/08/14.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView, AudioManagerDelegate {

    let avmgr :AudioManager = AudioManager.sharedInstance
    var imageView : UIImageView?
    var titleLabel : UILabel?
    var artistLabel : UILabel?
    var miniPlayButton : UIButton?
    var miniNextButton : UIButton?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMiniPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMiniPlayer(){
    
        avmgr.delegate = self
        
        let artsize:Int = Int(self.frame.size.height * 0.5)
        let size = CGSize(width: artsize, height: artsize)
        let artworkImage : UIImage?
        if let art : UIImage = avmgr.getCurrentTrackArtworkImage(size: size) {
            artworkImage = art
        }else{
            artworkImage = UIImage.init(named: "no_image.png")!
        }
        imageView = UIImageView.init(image: artworkImage)
        if let im : UIImageView = imageView {
            im.clipsToBounds = true
            im.layer.cornerRadius = 3.0
            let rect : CGRect = CGRect(x: Int(self.frame.size.width * 0.02), y: Int(self.frame.size.height * 0.1), width: artsize, height: artsize)
            im.layer.frame = rect
            self.addSubview(im)
            
            let label_font_size : Double = Double(self.frame.size.height * 0.2);
            let x : Int = Int(im.frame.origin.x + im.frame.size.width + self.frame.size.width * 0.02)
            let y : Int = Int(self.frame.size.height * 0.1)
            let width : Int = Int(self.frame.size.width * 0.6)
            let height : Int = Int(label_font_size * 1.4)
            
            let rect2 : CGRect = CGRect(x: x, y: y, width: width, height: height)
            titleLabel = UILabel.init(frame: rect2)
            if let tl : UILabel = titleLabel {
                tl.textColor = UIColor.white
                tl.textAlignment = NSTextAlignment.left
                tl.text = ""
                tl.font = UIFont.systemFont(ofSize: CGFloat(label_font_size))
                self.addSubview(tl)
                
                let y2 : Int = Int(tl.frame.size.height + self.frame.size.height * 0.1)
                let rect3 : CGRect = CGRect(x: x, y: y2, width: width, height: height)
                
                artistLabel = UILabel.init(frame: rect3)
                if let al : UILabel = artistLabel {
                    al.textColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                    al.textAlignment = NSTextAlignment.left
                    al.text = ""
                    al.font = UIFont.systemFont(ofSize: CGFloat(label_font_size))
                    self.addSubview(al)
                }
            }
            let imagename : String
            if avmgr.isPlaying() == true {
                imagename = "mini_pause.png"
            }else{
                imagename = "mini_play.png"
            }
            if let miniPlayImage : UIImage = UIImage.init(named: imagename) {
                let rect4 : CGRect =  CGRect(x: Int(Double(self.frame.size.width) - Double(artsize) * 1.1), y: Int(self.frame.size.height * 0.1), width: artsize, height: artsize)
                miniPlayButton = UIButton.init(frame: rect4)
                if let mp : UIButton = miniPlayButton {
                    mp.setBackgroundImage(miniPlayImage, for: UIControl.State.normal)
                    mp.addTarget(self, action: #selector(touchUpMiniPlayButton(_:)), for: UIControl.Event.touchUpInside)
                    self.addSubview(mp)
                }
            }
            if let miniNextImage : UIImage = UIImage.init(named: "mini_next.png") {
                let rect5 : CGRect =  CGRect(x: Int(Double(self.frame.size.width) - Double(artsize) * 2.2), y: Int(self.frame.size.height * 0.1), width: artsize, height: artsize)
                miniNextButton = UIButton.init(frame: rect5)
                if let mn : UIButton = miniNextButton {
                    mn.setBackgroundImage(miniNextImage, for: UIControl.State.normal)
                    mn.addTarget(self, action: #selector(touchUpMiniNextButton(_:)), for: UIControl.Event.touchUpInside)
                    self.addSubview(mn)
                }
            }
            updateLabels()
        }
    }
    
    //MARK:- Button selector
    @objc func touchUpMiniNextButton(_ sender: UIButton){
        avmgr.nextMusic()
    }
    
    @objc func touchUpMiniPlayButton(_ sender: UIButton){
        if avmgr.isPlaying() {
            avmgr.pauseMusic()
        }else{
            avmgr.playMusic()
        }
    }
    
    //MARK:- AudioManagerDelegate
    func audioStatus(state : AudioState){

        switch state {
        case AudioState.none:
            stopMusic()
        case AudioState.stop:
            stopMusic()
        case AudioState.play:
            updateLabels()
            playMusic()
        case AudioState.terminate:
            stopMusic()
        case AudioState.pause:
            stopMusic()
        }
    }
    
    func updateMusicTitleAvmgr(title: String){
        
    }
    
    //MARK:-
    func stopMusic(){
        if let miniPlayImage : UIImage = UIImage.init(named: "mini_play.png") {
            if let mp : UIButton = miniPlayButton {
                mp.setBackgroundImage(miniPlayImage, for: UIControl.State.normal)
            }
        }
    }
    
    func playMusic(){
        if let miniPlayImage : UIImage = UIImage.init(named: "mini_pause.png") {
            if let mp : UIButton = miniPlayButton {
                mp.setBackgroundImage(miniPlayImage, for: UIControl.State.normal)
            }
        }
        let artsize:Int = Int(self.frame.size.height * 0.5)
        let size = CGSize(width: artsize, height: artsize)
        if let art : UIImage = avmgr.getCurrentTrackArtworkImage(size: size) {
            if let im : UIImageView = imageView {
                im.image = art
            }
        }
    }
    
    func updateLabels(){
        let artsize:Int = Int(self.frame.size.height * 0.5)
        let size = CGSize(width: artsize, height: artsize)
        if let art : UIImage = avmgr.getCurrentTrackArtworkImage(size: size) {
            if let im : UIImageView = imageView {
                im.image = art
            }
        }
        if let tl : UILabel = titleLabel {
            if let title_str: String = avmgr.getCurrentTitleString() {
                tl.text = title_str
            }else{
                tl.text = ""
            }
        }
        if let al : UILabel = artistLabel {
            if let artist_str: String = avmgr.getCurrentArtistString() {
                al.text = artist_str
            }else{
                al.text = ""
            }
        }
    }
}
