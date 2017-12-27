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
    lazy var  photoService = PhotoService(container: collectionView!)
    var photos = [Photo]()

    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
        }()
    
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
        /*
        if let photo = photosCache[indexPath.row] {
            cell.FriendsDataCellImage.image = photo
        } else {
            loadPhotos(indexPath: indexPath)
        }
*/
//        cell.FriendsDataCellImage.setImageFromURl(stringImageUrl: photo)

        //третий рефакторинг
        //cell.FriendsDataCellImage.image = photoService.photo(atIndexpath: indexPath, byUrl: photos[indexPath.row].photoUrl)
        
        //print("indexPath1 = \(indexPath), url1 = \(photos[indexPath.row].photoUrl)")
        
        let getCacheImage = GetCacheImage(url:photos[indexPath.row].photoUrl)
        
        //создали задачу установки фото
        let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, collectionView: collectionView)
        //сделали ее зависимой от загрузки фото
        setImageToRow.addDependency(getCacheImage) 
        /*
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.FriendsDataCellImage.image = getCacheImage.outputImage
                }
            
        }*/
        //добавили в очередь загрузку фото
        //queue.addOperation(getCacheImage)
        //OperationQueue.main.addOperation(getCacheImage)

        queue.addOperation(getCacheImage)

        //добавили установку фото в главную очередь
        OperationQueue.main.addOperation(setImageToRow)
        
        let textLabel = String(indexPath.row) + " " + photos[indexPath.row].photoUrl
        cell.setLabel(text: textLabel)
        //cell.FriendsDataCellLabel.text=String(indexPath.row) + " " + photos[indexPath.row].photoUrl
        
        return cell
    }

    func showUPhoto() {
        mainService.loadFriendFotoVK(forUser: userId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView?.reloadData()
        }
    }

    /*
    func loadPhotos(indexPath: IndexPath) {
        photoService.downloadPhoto(byUrl: photos[indexPath.row].photoUrl) { [weak self] image in
            self?.photosCache[indexPath.row] = image
            self?.collectionView?.reloadItems(at: [indexPath])
        }
    }
*/
    
}
