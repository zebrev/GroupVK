//
//  NewParser.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 31.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import SwiftyJSON


extension ParserFactory {
    struct NewsFeed: JsonParser1 {
        
        static let deepType = [
            "post": nil,
            "wall_photo": "photos",
            "photo": "photos",
            "photo_tag": "profiles",
            "friend": "friends",
            "note": "profiles",
            "audio": "audio",
            "video": "video"
        ]
        
        let jsonToNew = { (json: JSON, groups: [Group], users: [User]) -> News in
            var new = News()
            let type = json["type"].stringValue
            
            new.id = json["post_id"].intValue
            new.sourceId = json["source_id"].intValue
            
            var json = json
            
            if let deepTypeOptional = deepType[type], let type = deepTypeOptional  {
                json = json[type]["items"][0]
            }
            
            
            new.likesCount = json["likes"]["count"].intValue
            new.repostsCount = json["reposts"]["count"].intValue
            new.commentsCount = json["comments"]["count"].intValue
            new.viewsCount = json["views"]["count"].intValue
            new.text = json["text"].stringValue
            
            var photoLink = ""
            photoLink = json["copy_history"][0]["attachments"][0]["photo"]["photo_130"].stringValue
            if (photoLink.isEmpty) {
                photoLink = json["attachments"][0]["photo"]["photo_130"].stringValue
            }
            
            new.photoLink=photoLink
            /*
            if (new.id == 11063) {
                print("copy_history1 = ",json["copy_history"])
                print("copy_history2 = ",json["copy_history"][0]["attachments"])
                print("copy_history2 = ",json["copy_history"][0]["attachments"][0]["photo"]["photo_130"])
                print("copy_history3 = ",json["copy_history"]["post_source"])
                
                print(new.photoLink)
            }
*/
            if new.sourceId > 0 {
                new.user = users.filter { $0.id == new.sourceId }.first
            } else {
                new.group = groups.filter { $0.id == abs(new.sourceId) }.first
            }
            
            return new
        }
        
        func parse(_ json: JSON) -> [AnyObject] {
            let groups = json["response"]["groups"].map { Group(json: $0.1) }
            let users = json["response"]["profiles"].map { User(json: $0.1) }
            return json["response"]["items"].flatMap { jsonToNew($0.1, groups, users) }
        }
        
    }
}

