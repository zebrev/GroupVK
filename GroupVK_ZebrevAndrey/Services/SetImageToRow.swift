//
//  SetImageToRow.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 09.11.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import UIKit

class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: CollectionViewCellFriendsData?
    
    init(cell: CollectionViewCellFriendsData, indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell

        //print("indexPath set1 = \(indexPath)")
    }
    
    override func main() {
        guard let collectionView = collectionView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        //print("indexPath set2= \(indexPath), \(collectionView.indexPathsForVisibleItems)")
        
        /*if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCellFriendsData  {
            cell.FriendsDataCellImage.image = image
        }
        */
        if let newIndexPath = collectionView.indexPath(for: cell), newIndexPath == indexPath {
            cell.FriendsDataCellImage.image = image
            }
            else if collectionView.indexPath(for: cell) == nil {
                cell.FriendsDataCellImage.image = image
            
        }       
    }
}

