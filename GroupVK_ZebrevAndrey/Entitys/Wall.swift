//
//  Wall.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 06.12.2017.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import SwiftyJSON

class Walls {
    var id                  = 0
    var text                = ""
    var photoLink: String?
 
    convenience init( json:   JSON)  {
        
        self.init()
        
        id              = json["id"].intValue
        text            = json["copy_history"][0]["text"].stringValue
        
        if (text.isEmpty) {
            text        = json["text"].stringValue
            
        }

        var photoLinkStr = ""
        photoLinkStr       = json["copy_history"][0]["attachments"][0]["photo"]["photo_130"].stringValue

        if (photoLinkStr.isEmpty && json["attachments"][0]["type"].stringValue == "link") {
            photoLinkStr = json["attachments"][0]["link"]["photo"]["photo_130"].stringValue
            text = json["attachments"][0]["link"]["title"].stringValue
        }
 
        if (photoLinkStr.isEmpty && json["attachments"][0]["type"].stringValue == "video") {
            photoLinkStr = json["attachments"][0]["video"]["photo_130"].stringValue
            text = json["attachments"][0]["video"]["title"].stringValue
        }
        photoLink=photoLinkStr

                        print("id = \(id), photo = \(photoLink!)")

    }

}
