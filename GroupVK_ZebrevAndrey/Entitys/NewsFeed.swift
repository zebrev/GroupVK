//
//  NewsFeedService.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 30.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation

class News {
    var id                  = 0
    var sourceId            = 0
    var likesCount          = 0
    var repostsCount        = 0
    var commentsCount       = 0
    var viewsCount          = 0
    var text                = ""
    var photoLink: String?
    var user: User?
    var group: Group?

}

