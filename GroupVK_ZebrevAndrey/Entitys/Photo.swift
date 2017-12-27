//
//  Photo.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 06.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
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



