//
//  AlbumDetailViewController.swift
//  SimpleSwiftAudioPlayer
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
    public var album_index : Int = 0
    public var track_index : Int = -1
    
    @IBOutlet weak var _musicTableView: UITableView!
    
    var selectedIndexRow :Int = -1
    let avmgr :AudioManager = AudioManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._musicTableView.tableFooterView = UIView()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(receiveChangeMusic), name: Notification.Name("kChangeMusicNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func receiveChangeMusic(notification : NSNotification){
        if album_index == avmgr.album_index {
            if track_index != avmgr.currentTrackIndex {
                let indexPath : NSIndexPath = NSIndexPath.init(row:  avmgr.currentTrackIndex, section: 0)
                _musicTableView.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.middle)
                _musicTableView.setNeedsDisplay()
                _musicTableView.reloadData()
                track_index = avmgr.currentTrackIndex
            }
        }
    }

    @IBAction func touchUpUnderButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AlbumDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)

        let track : Track = tracks[indexPath.row]
        let title_label : UILabel = cell.contentView.viewWithTag(1) as! UILabel
        title_label.text = track.title

        if track_index == indexPath.row {
            title_label.textColor = UIColor.green
        }else{
            title_label.textColor = UIColor.white
        }

        let info_label = cell.contentView.viewWithTag(2) as! UILabel
        
        let total_sec : Int = track.duration
        let min : Int = total_sec / 60
        let sec : Int = total_sec % 60
        let info = String(format:"%d:%d", min, sec)
        info_label.text = info
        
        let no_label = cell.contentView.viewWithTag(3) as! UILabel
        let no_str = String(format:"%d", indexPath.row + 1)
        no_label.text = no_str
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
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
        
        if album_index != avmgr.album_index {
            avmgr.tracks = tracks
            avmgr.album_index = album_index
            avmgr.album_title = album.title
            avmgr.albumArtworkImage = album.artworkImage
        }
        
        avmgr.terminateAudioPlayer()
        avmgr.startSelectMusic(index: indexPath.row)
    }
}

