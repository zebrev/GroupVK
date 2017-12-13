//
//  CollectionViewControllerFriendsData.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class CollectionViewControllerFriendsData: UICollectionViewController {

    //var photo       = ""

    //по id лучше - сразу фотки пользователя
    var userId      = 0

    let mainService = MainService()
    let photoService = PhotoService()

    var photos = [Photo]()
    var photosCache: [Int: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        showUPhoto()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsDataCell", for: indexPath) as! CollectionViewCellFriendsData
       
        if let photo = photosCache[indexPath.row] {
            cell.FriendsDataCellImage.image = photo
        } else {
            loadPhotos(indexPath: indexPath)
        }

//        cell.FriendsDataCellImage.setImageFromURl(stringImageUrl: photo)

        return cell
    }

    func showUPhoto() {
        mainService.loadFriendFotoVK(forUser: userId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView?.reloadData()
        }
    }
    
    func loadPhotos(indexPath: IndexPath) {
        photoService.downloadPhoto(byUrl: photos[indexPath.row].photoUrl) { [weak self] image in
            self?.photosCache[indexPath.row] = image
            self?.collectionView?.reloadItems(at: [indexPath])
        }
    }

    
}
