//
//  DetailViewController.swift
//  RSSReader
//
//  Created by Roland Tolnay on 14/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
   
   static var identifier: String {
      return String(describing: self)
   }
   
   // MARK: -
   // MARK: IBOutlets
   // --------------------
   @IBOutlet weak var itemImageView: UIImageView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descriptionLabel: UILabel!
   
   // MARK: -
   var feedItem: FeedItem?
   
   // MARK: -
   // MARK: View Lifecycle
   // --------------------
   override func viewDidLoad() {
      super.viewDidLoad()
   
      setupFromFeedItem()
      setupGestureRecognizers()
   }
   
   // MARK: -
   // MARK: Setup
   // --------------------
   private func setupFromFeedItem() {
      guard let feedItem = feedItem else {
         dismiss()
         return
      }
      titleLabel.text = feedItem.title
      descriptionLabel.text = feedItem.description
      descriptionLabel.sizeToFit()
      itemImageView.image = UIImage(named: "image-placeholder")
      if let imageUrl = feedItem.imageUrl {
         Nuke.loadImage(with: imageUrl, into: itemImageView)
      }
   }
   
   private func setupGestureRecognizers() {
      let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(gesture:)))
      swipeDown.direction = .down
      self.view.addGestureRecognizer(swipeDown)
   }
   
   // MARK: -
   // MARK: Actions
   // --------------------
   @IBAction func onClosePressed(_ sender: UIButton) {
      dismiss()
   }
   
   @IBAction func onViewTrailerPressed(_ sender: UIButton) {
      if let feedItem = feedItem {
         UIApplication.shared.openURL(feedItem.externalUrl)
      }
   }
   
   @objc private func onSwipe(gesture: UIGestureRecognizer) {
      dismiss()
   }
   
   private func dismiss() {
      dismiss(animated: true, completion: nil)
   }
}
