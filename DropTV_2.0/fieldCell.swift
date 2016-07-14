//
//  fieldCell.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/19.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit

class fieldCell: UITableViewCell {

   
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var fieldInfo: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
