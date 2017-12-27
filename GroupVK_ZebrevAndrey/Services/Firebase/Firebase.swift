//
//  Firebase.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 17.11.2017.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
/*
struct UserFireBase {
    let id : String
    let enteredGroups : [EnteredGroup]
    
    var toAnyObject: Any {
        return [
            "id" : id,
            "enteredGroups" : enteredGroups.reduce([Int : Any](), { (prevResult, enteredGroups) in
                var prevResult = prevResult
                prevResult[enteredGroups.groupId] = enteredGroups.toAnyObject
                return prevResult
                
            } )
            
        ]
    }
    
}
*/

struct EnteredGroup {
    let groupId : Int
    
    var toAnyObject: Any {
        return [
            "groupId" : groupId
        ]
    }
    
}
