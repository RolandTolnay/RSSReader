//
//  FeedItemCell.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var itemImageView: UIImageView!
   
   static var nib: UINib {
      return UINib(nibName: String(describing: self), bundle: nil)
   }
   
   static var reuseIdentifier: String {
      return String(describing: self)
   }
   
   func setupWith(title: String, description: String? = nil) {
      titleLabel.text = title
      descriptionLabel.text = description
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      itemImageView.contentMode = .scaleAspectFit
      descriptionLabel.lineBreakMode = .byWordWrapping
      descriptionLabel.numberOfLines = 2
   }
}
