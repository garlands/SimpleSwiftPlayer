//
//  AlbumDetailViewController.swift
//  SimpleSwiftPlayer
//
//  Created by Masahiro Tamamura on 2018/08/12.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    func updateMusicTitleAvmgr(title: String) {
        updateLabels()
    }
    
    
    public var album : Album!
    public var tracks : Array<Track> = []
    
    @IBOutlet weak var _musicTableView: UITableView!
    
    var selectedIndexRow :Int = -1
    let avmgr :AudioManager = AudioManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()


        self._musicTableView.tableFooterView = UIView()
//        avmgr.delegate = self

        let nc = NotificationCenter.default
//        nc.addObserver(self, selector: #selector(receiveChangeAudioState), name: Notification.Name("kChangeAudioStateNotification"), object: nil)
        nc.addObserver(self, selector: #selector(receiveChangeMusic), name: Notification.Name("kChangeMusicNotification"), object: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func receiveChangeMusic(notification : NSNotification){
        if let userInfo = notification.userInfo {
            let state : Int = userInfo["state"]! as! Int
            print("\(state)")
        }
    }
    
    /*
    // MARK: - AudioManagerDelegate
    func audioStatus(state : AudioState) {
        switch(state){
        case .play:
            do {
                print("play")
                let indexPath : IndexPath = IndexPath(item: self.selectedIndexRow, section: 0)
                let cell: UITableViewCell = self._musicTableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
                
                let gif_imageview = cell.contentView.viewWithTag(4) as! UIImageView
                gif_imageview.isHidden = false
            }
            break;
        case .stop:
            do {
                print("stop")
                let indexPath : IndexPath = IndexPath(item: self.selectedIndexRow, section: 0)
                let cell: UITableViewCell = self._musicTableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
                
                let gif_imageview = cell.contentView.viewWithTag(4) as! UIImageView
                gif_imageview.isHidden = true
            }
            break;
        case .forword:
            print("forword")
            break;
        case .rewind:
            print("rewind")
            break;
        case .pause:
            print("pause")
            break;
        }
    }*/

    @IBAction func touchUpUnderButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension AlbumDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt index row: \(indexPath.row)  section :\(indexPath.section)")
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)

//        let track : Track = tracks[indexPath.row]
        let title_label = cell.contentView.viewWithTag(1) as! UILabel
        title_label.text = avmgr.getSelectTitle(index: indexPath.row)

        let info_label = cell.contentView.viewWithTag(2) as! UILabel
        
        let total_sec : Int = avmgr.getSelectDuringTime(index: indexPath.row)
        let min : Int = total_sec / 60
        let sec : Int = total_sec % 60
        let info = String(format:"%d:%d", min, sec)
        info_label.text = info
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(avmgr.countTracks())")
//        if section == 0 {
            return avmgr.countTracks()
//        }else{
//            return 0
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func updateLabels(){
        
    }
}

extension AlbumDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        
        avmgr.terminateAudioPlayer()
        avmgr.startSelectMusic(index: indexPath.row)
    }
}

