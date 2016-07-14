//
//  pocketCell.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/18.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import Foundation

class pocketCell: UITableViewCell {
    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myCreateTime: UILabel!
    @IBOutlet weak var myLikeButton: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var isReadImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}