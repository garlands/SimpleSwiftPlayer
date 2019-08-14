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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let al = Albums.init()
        albums = al.musicLibraryAlbums()
        
        // Register cell classes
        let title = avmgr.getCurrentAlbumTitle()
        print(title)
//        albums = AlbumLists.musicLibraryAlbums()
        
//        albums = Album.musicLibraryAlbums()
        if (albums?.count)! > 0 {
            let album : Album = albums![0];
            print(album.title)
        }
        /*
        let cellnumber = 2
        let bounds = UIScreen.main.bounds
//        let space:CGFloat = bounds.size.width * 0.01
//        let bar:CGFloat = bounds.size.height * 0.03
        let layout = UICollectionViewFlowLayout()
//        let w:Int = Int(Float(bounds.size.width - space * 3) / Float(cellnumber))
//        let h:Int = Int(Float(bounds.size.height + bar - space * 3) / Float(cellnumber))
        
        let space = Int(bounds.size.width * 0.01)
        let bar = Int(bounds.size.height * 0.03)
        let w = (Int(bounds.size.width) - space * 3) / cellnumber
        let h = (Int(bounds.size.width) + bar - space * 3) / cellnumber

        layout.itemSize = CGSize(width: w, height: h)
        collectionView?.collectionViewLayout = layout
        */
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    func musicLibraryAlbums() -> Array<Album> {
//        print("artist \(self.artist) title\(self.title)")
        var albums : Array<Album> = Array()
        let query = MPMediaQuery.albums()
//        query.addFilterPredicate(MPMediaPropertyPredicate(value: "Album Title", forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo))
        
        let albumlists = query.collections
        for albumlist : MPMediaItemCollection in albumlists! {
            let item = albumlist.representativeItem
            let artist = item?.value(forProperty: MPMediaItemPropertyArtist)
            let title = item?.value(forProperty: MPMediaItemPropertyAlbumTitle)
            
            let artwork = item!.value(forProperty:MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
//            MPMediaItemArtwork.init(image: UIImage (data: (self.musicModel?.musicimg)!)!)] as [String : Any]
            let album : Album = Album.init(title: title as! String, artist: artist as! String, artwork: artwork )
            albums.append(album)
            
        }
        return albums
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
/*
         let next = segue.destination as? AlbumDetailViewController
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            let album : Album = albums![indexPath.row]
            next?.album = album
            let albumtitle : String = album.title
            let tr = Tracks.init()
            next?.tracks = tr.musicLibraryTracks_album(albumTitle: albumtitle)
        }
*/
//        let cell : UICollectionViewCell = sender as! UICollectionViewCell
//        let indexPath : indexPath = self.collectionView?.indexPath(for: cell)
//        next?.album = albums[indexPath.row]
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let als : Array = albums {
            return als.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        let album : Album = albums![indexPath.row]
        let artwork_imageview = cell.contentView.viewWithTag(1) as! UIImageView
//        let artwork : MPMediaItemArtwork = album.artwork!
//        let artworkImage : UIImage = artwork.image(at:CGSize(width:80, height:80))!
        
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
        avmgr.album_index = indexPath.row
        avmgr.albums = albums
        avmgr.album_title = album.title
        avmgr.setupAlbum()
        let tr = Tracks.init()
        avmgr.tracks = tr.musicLibraryTracks_album(albumTitle: album.title)
        
        if let tr2 = avmgr.tracks {
            print("\(tr2.count)")
        }
        
        
        
        let next:UIViewController = UIStoryboard(name: "AlbumDetail", bundle: nil).instantiateViewController(withIdentifier: "albumDetailViewController")
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
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
