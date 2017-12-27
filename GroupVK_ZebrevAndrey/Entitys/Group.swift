//
//  Group.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 06.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class Group : Object {
     @objc  dynamic  var id:Int          = 0
     @objc  dynamic  var name: String    = ""
     @objc  dynamic  var photo: String   = ""
     @objc  dynamic  var countUser: Int  = 0
     @objc  dynamic  var example         = "group"

    override  static func  primaryKey( ) -> String? {
        return "id"
    }
    
    override  static func indexedProperties( ) -> [String]  {
        return ["name"]
    }
    
    override  static func ignoredProperties( ) -> [String]  {
        return ["example"]
    }

    convenience init( json:   JSON)  {
        
        self.init()

        id         = json["id"].intValue
        name       = json["name"].stringValue
        photo      = json["photo_200"].stringValue
        countUser  = json["members_count"].intValue
    }

}

extension  Group{
    //имплементируем протокол для вывода в консоль
    override var description:   String {
        
        return  "\nГруппа \(id) - название \(name), фото \(photo). Число участников = \(countUser)"
    }
}

