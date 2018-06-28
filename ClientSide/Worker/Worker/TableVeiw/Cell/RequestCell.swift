//
//  RequestCell.swift
//  Worker
//
//  Created by TONY on 17/04/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var lableIdRequest: UILabel!
    @IBOutlet weak var labelDates: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
