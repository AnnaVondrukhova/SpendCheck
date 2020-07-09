//
//  CheckCell.swift
//  SpendCheck
//
//  Created by Anya on 06.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class CheckCell: UITableViewCell {

    @IBOutlet var shopLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
