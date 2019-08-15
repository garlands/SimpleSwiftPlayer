//
//  AlbumCollectionViewController.swift
//  SimpleSwiftAudioPlayer
//
//  Created by Masahiro Tamamura on 2018/08/11.
//  Copyright © 2018年 Masahiro Tamamura. All rights reserved.
//

import UIKit
import MediaPlayer

private let reuseIdentifier = "AlbumCell"
private var albums : Array<Album>?

class AlbumCollectionViewController: UICollectionViewController {
    
    let avmgr :AudioManager = AudioManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let al = Albums.init()
        albums = al.musicLibraryAlbums()
        
        if (albums?.count)! > 0 {
            let album : Album = albums![0];
            print(album.title)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let als : Array = albums {
            return als.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let album : Album = albums![indexPath.row]
        let artwork_imageview = cell.contentView.viewWithTag(1) as! UIImageView
        
        artwork_imageview.image = album.artworkImage

        if let title_label : UILabel = cell.contentView.viewWithTag(2) as? UILabel {
            title_label.text = album.title
        }
        if let artist_label : UILabel = cell.contentView.viewWithTag(3) as? UILabel {
            artist_label.text = album.artist
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album : Album = albums![indexPath.row]
        let tr = Tracks.init()
        
        let next:AlbumDetailViewController = UIStoryboard(name: "AlbumDetail", bundle: nil).instantiateViewController(withIdentifier: "albumDetailViewController") as! AlbumDetailViewController
        next.album = album
        next.album_index = indexPath.row
        next.tracks = tr.musicLibraryTracks_album(albumTitle: album.title)
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension AlbumCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellnumber = 2
        let bounds = UIScreen.main.bounds
//        let space = Int(bounds.size.width * 0.01)
//        let bar = Int(bounds.size.height * 0.03)
//        let w = (Int(bounds.size.width) - space * 3) / cellnumber
//        let h = (Int(bounds.size.width) + bar - space * 3) / cellnumber
//        return CGSize(width: w, height: h)
        return CGSize(width: bounds.size.width, height: bounds.size.width)
    }
    
}
