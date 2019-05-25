//
//  CourseCell.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 24/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCOurce: UILabel!
    
    func initCell (currency: Currency) {
        imageFlag.image = currency.imageFlag
        labelCurrencyName.text = currency.Name
        labelCOurce.text = currency.Value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
