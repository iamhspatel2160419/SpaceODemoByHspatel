//
//  CustomCellTableViewCell.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var imageView_: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
