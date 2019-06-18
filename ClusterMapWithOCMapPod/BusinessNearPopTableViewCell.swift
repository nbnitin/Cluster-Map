//
//  BusinessNearPopTableViewCell.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 01/03/16.
//  Copyright © 2016 Nasib Ali Ansari. All rights reserved.
//

import UIKit

class BusinessNearPopTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
