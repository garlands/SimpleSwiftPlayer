//
//  MiniPlayerTabBar.swift
//  simpleswiftplayer
//
//  Created by Masahiro Tamamura on 2019/08/12.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit

class MiniPlayerTabBar: UITabBar {

    var miniPlayerView : MiniPlayerView?
    var initialized : Bool = false

    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.darkGray
        
        if let _ : MiniPlayerView = miniPlayerView {
            print("alread created")
        }else{
            createMiniPlayer()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var ret_size : CGSize = super.sizeThatFits(size)
        ret_size.height = ret_size.width / 4;
        return ret_size;
    }
    
    func createMiniPlayer(){
        miniPlayerView = MiniPlayerView.init(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height - self.safeAreaInsets.bottom))
        miniPlayerView?.backgroundColor = UIColor.darkGray
        self.addSubview(miniPlayerView!)
    }
    
}
