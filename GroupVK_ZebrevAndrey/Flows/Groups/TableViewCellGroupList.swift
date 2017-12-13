//
//  TableViewCellGroupList.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

class TableViewCellGroupList: UITableViewCell {

    var idGroup : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var GroupListCellLabel: UILabel!

    @IBOutlet weak var GroupListCellImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
