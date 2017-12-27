//
//  User.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 06.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User : Object {
     @objc  dynamic  var id:Int          = 0
     @objc  dynamic  var firstName       = ""
     @objc  dynamic  var lastName        = ""
     @objc  dynamic  var nickname        = ""

     //не всегда указано photo_200_orig
     @objc  dynamic  var photoUrl        = ""
     @objc  dynamic  var photo50Url      = ""
     @objc  dynamic  var example         = "user"       //test
    
     @objc  dynamic  var fullName: String {
        return firstName + " " + nickname + " " + lastName
    }

    override  static func  primaryKey( ) -> String? {
         return "id"
    }

    override  static func indexedProperties( ) -> [String]  {
        return ["firstName"]
    }

    override  static func ignoredProperties( ) -> [String]  {
        return ["example"]
    }

    
    convenience init(json:JSON) {
        
        self.init()
        
        id         = json["id"].intValue
        firstName  = json["first_name"].stringValue
        lastName   = json["last_name"].stringValue
        nickname   = json["nickname"].stringValue
        photoUrl   = json["photo_200_orig"].stringValue
        photo50Url = json["photo_50"].stringValue
    }

    /*
    class func getUserVk(mainService : MainService) -> [User] {
        
        //let typeOfObject = mainService.dynamicType
        //var freshInstance = typeOfObject()
        
        var arrUser = [User]()
        mainService.loadFriendVK() { (arrResult) in
            
            print("Друзья: \(arrResult)")
            arrUser = arrResult
            
        }
        return arrUser
    }
    */
}


extension  User {
    //имплементируем протокол для вывода в консоль
    override var description:   String {
        
        return  "\nПользователь \(id) - \(fullName). photoUrl=\(photoUrl), photo50Url=\(photo50Url)"
    }
}

