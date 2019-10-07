//
//  listOfNewsTableViewCell.swift
//  Task
//
//  Created by Arjun babu k.s on 10/7/19.
//  Copyright © 2019 Arjun babu k.s. All rights reserved.
//

import UIKit

class listOfNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var des: UILabel!
    
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
