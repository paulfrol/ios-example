//
//  CoursecellCell.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 24/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class CoursecellCell: UITableViewCell {
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCource: UILabel!
    
    func initCell(currency: Currency) {
        imageFlag.image = currency.imageFlag
        labelCurrencyName.text = currency.Name
        labelCource.text = currency.Value
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
