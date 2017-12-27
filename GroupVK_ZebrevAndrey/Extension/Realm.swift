//
//  Realm.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 16.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//  Copyright © 2017 JonFir. All rights reserved.`
//

import Foundation

import RealmSwift

extension Realm {
    
    static func replaceAllObjectOfType<T: Object>(toNewObjects objects: [T]) {
        do {
            let realm = try Realm()
            let oldObjects =  realm.objects(T.self)
            
            realm.beginWrite()
            realm.delete(oldObjects)
            realm.add(objects)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
}
