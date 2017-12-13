//
//  TableViewCellGroupListData.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

class TableViewCellGroupListData: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var GroupListDataCellLabel: UILabel!
    
    @IBOutlet weak var GroupListDataCellNumberOfPersonLabel: UILabel!

    @IBOutlet weak var GroupListDataCellImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
