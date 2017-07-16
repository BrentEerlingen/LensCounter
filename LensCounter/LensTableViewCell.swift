//
//  LensTableViewCell.swift
//  LensCounter
//
//  Created by Brent Eerlingen on 2/07/17.
//  Copyright © 2017 Brent Eerlingen. All rights reserved.
//

import UIKit

class LensTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var imageLogoLens: UIImageView!
    @IBOutlet weak var brandLens: UILabel!
    @IBOutlet weak var typeLens: UILabel!
    @IBOutlet weak var counterLens: UILabel!
    @IBOutlet weak var activatedLens: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
