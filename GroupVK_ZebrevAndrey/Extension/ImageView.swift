//
//  ImageView.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 16.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
