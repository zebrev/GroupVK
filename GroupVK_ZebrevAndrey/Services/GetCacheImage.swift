//
//  Cache.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 09.11.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import UIKit

class GetCacheImage: Operation {
    private let cacheLifeTime: TimeInterval = 2592000
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
        }
        return pathName
        
    }()

    private lazy var filePath: String? = { guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hasheName).path
        
    }()
    
    private let url: String
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
        
    }

    override func main() {
        guard filePath != nil && !isCancelled else { return }
        
        if getImageFormChache() { return }
        guard !isCancelled else { return }
        
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        saveImageToChache()

    }
    
    private func getImageFormChache() -> Bool {
        
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return false }
        
        self.outputImage = image
        return true
        
    }
    
    private func downloadImage() -> Bool  {
        
        guard let url = URL(string: url),
            let data = try? Data.init(contentsOf: url),
            let image = UIImage(data: data) else { return false }
        
        self.outputImage = image
        return true
        
    }
    
    private func saveImageToChache() {
        guard let fileName = filePath, let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }

}

class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?

    init(indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        
    }
    
    override func main() {
        guard let collectionView = collectionView,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCellFriendsData  {
                cell.FriendsDataCellImage.image = image
        }
    }
}

