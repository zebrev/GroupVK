//
//  ParserFactory.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 31.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation

struct ParserFactory {
    
    func newsFeed() -> JsonParser1 {
        return ParserFactory.NewsFeed()
    }
}

