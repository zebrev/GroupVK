//
//  Parser.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 31.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonParser1 {
    func parse(_ json: JSON) -> [AnyObject]
}
