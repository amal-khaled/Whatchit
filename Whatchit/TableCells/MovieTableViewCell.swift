//
//  MovieTableViewCell.swift
//  Whatchit
//
//  Created by Amal Elgalant on 7/5/19.
//  Copyright © 2019 Amal Elgalant. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var overView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overView.sizeToFit()
        title.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
