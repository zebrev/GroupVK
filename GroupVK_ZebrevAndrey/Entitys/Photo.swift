//
//  Photo.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 06.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyVK
import RealmSwift


class Photo : Object {
     @objc  dynamic  var id:Int         = 0
     @objc  dynamic  var photoUrl       = ""
     @objc  dynamic  var ownerId:Int    = 0
  
    convenience init( json:   JSON)  {
        
        self.init()

        id              = json["id"].intValue
        photoUrl        = json["photo_130"].stringValue
        ownerId         = json["owner_id"].intValue
    }
    

}


extension  Photo {
    override var description:   String {
        
        return  "\nФото \(id) - название файла \(photoUrl), владелец \(ownerId)"
    }

}


//здесь скачиваем фото по заданному пути
class PhotoService {
    
    private let syncQueue = DispatchQueue(label: "ru.jonfir.gbvk.photoService", qos: .userInteractive)
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }

    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }

    private var images = [String: UIImage]()
  
    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = images[url] {
            image = photo
        } else {
            loadPhoto(atIndexpath: indexPath, byUrl: url)
        }
        return image
    }
/*
    photoService.downloadPhoto(byUrl: photo) { [weak self] image in
    self?.usersPhoto[indexPath.row] = image
    self?.tableView.reloadRows(at: [indexPath], with: .none)
    }
*/

    private func loadPhoto(atIndexpath indexPath: IndexPath, byUrl url: String) {
        Alamofire.request(url).responseData(queue: syncQueue) { [weak self] response in
            guard
                let data = response.data,
                let image = UIImage(data: data) else { return }
            
            self?.images[url] = image
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexpath: indexPath)
            }
            
        }
    }

}


fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath indexPath: IndexPath)
}

extension PhotoService {
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}
