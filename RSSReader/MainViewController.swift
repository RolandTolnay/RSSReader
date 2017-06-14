//
//  ViewController.swift
//  RSSReader
//
//  Created by Roland Tolnay on 6/13/17.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import UIKit
import Nuke
import PullToRefreshSwift

class MainViewController: UIViewController {
   
   // MARK: -
   // MARK: IBOutlets
   // --------------------
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var noDataLabel: UILabel!
   fileprivate var activityIndicator: UIActivityIndicatorView!
   
   // MARK: -
   fileprivate var activityCount: Int = 0
   
   // MARK: -
   fileprivate let feedReader: FeedReader = FeedItemManager()
   fileprivate var feedItems = [FeedItem]() {
      didSet {
         DispatchQueue.main.async {
            self.updateLayout(isFeedEmpty: self.feedItems.isEmpty)
         }
      }
   }
   
   // MARK: -
   // MARK: View Lifecycle
   // --------------------
   override func viewDidLoad() {
      super.viewDidLoad()
      
      noDataLabel.isHidden = true
      setupTableView()
      setupLoadingIndicator()
      
      refreshFeed() {
         // For testing purposes
         // self.showAlert(with: "Succesfully loaded \(self.feedItems.count) trailers")
      }
   }
   
   // MARK: -
   // MARK: Setup
   // --------------------
   private func setupTableView() {
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(FeedItemCell.nib, forCellReuseIdentifier: FeedItemCell.reuseIdentifier)
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 91 // Matches value from cell nib
      
      tableView.addPullRefresh() { [weak self] in
         self?.refreshFeed() {
            self?.tableView.stopPullRefreshEver()
         }
      }
   }
   
   private func setupLoadingIndicator() {
      let indicatorSize = CGFloat(66.0)
      let frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
      activityIndicator = UIActivityIndicatorView(frame: frame)
      activityIndicator.center = self.view.center
      activityIndicator.activityIndicatorViewStyle = .gray
      
      self.view.bringSubview(toFront: activityIndicator)
      self.view.addSubview(activityIndicator)
   }
   
   // MARK: -
   // MARK: Actions
   // --------------------
   @IBAction func onChangeRssPressed(_ sender: UIBarButtonItem) {
      showChangeRss()
   }
   
   fileprivate func showChangeRss() {
      let alert = UIAlertController(title: "Change RSS Feed URL", message: "", preferredStyle: .alert)
      let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
         let textField = alert.textFields![0] as UITextField
         guard let text = textField.text,
            !text.isEmpty,
            let url = URL(string: text) else { return }
         
         FeedUrlStorage.shared.saveUrl(url)
         self.refreshFeed()
      })
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      alert.addTextField() { textfield in
         textfield.text = FeedUrlStorage.shared.rssUrl.absoluteString
         textfield.clearButtonMode = .whileEditing
         textfield.keyboardType = .URL
      }
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      
      self.present(alert, animated: true, completion: nil)
   }
   
   fileprivate func refreshFeed(onFinish: (()->())? = nil) {
      incrementActivity()
      
      let url = FeedUrlStorage.shared.rssUrl
      feedReader.fetchFeedItems(from: url) { feedTitle, items, error in
         self.decrementActivity()
         
         defer { onFinish?() }
         guard error == nil else {
            DispatchQueue.main.async {
               self.showAlert(with: error!.localizedDescription)
               self.updateLayout(isFeedEmpty: true)
            }
            return
         }
         DispatchQueue.main.async {
            self.navigationItem.title = feedTitle
         }
         guard let items = items, !items.isEmpty else {
            self.feedItems = []
            return
         }
         
         self.feedItems = items
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
      }
   }
   
   // MARK: -
   fileprivate func showAlert(with message: String) {
      let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      self.present(alert, animated: true, completion: nil)
   }
   
   fileprivate func updateLayout(isFeedEmpty: Bool) {
      tableView.isHidden = isFeedEmpty
      noDataLabel.isHidden = !isFeedEmpty
   }
}

// MARK: -
// MARK: Loading
// --------------------
extension MainViewController {
   
   fileprivate func incrementActivity() {
      activityCount += 1
      if activityCount > 0 {
         DispatchQueue.main.async {
            self.startLoading()
         }
      }
   }
   
   fileprivate func decrementActivity() {
      activityCount -= 1
      if activityCount < 0 {
         print("Unbalanced calls to incrementActivity and decrementActivity.")
         activityCount = 0
      }
      if activityCount == 0 {
         DispatchQueue.main.async {
            self.stopLoading()
         }
      }
   }
   
   private func startLoading() {
      activityIndicator.startAnimating()
      tableView.isHidden = true
      self.navigationItem.title = ""
   }
   
   private func stopLoading() {
      activityIndicator.stopAnimating()
      tableView.isHidden = false
   }
}

// MARK: -
// MARK: UITableViewDataSource
// --------------------
extension MainViewController: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return feedItems.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemCell.reuseIdentifier, for: indexPath) as! FeedItemCell
      let feedItem = feedItems[indexPath.row]
      
      cell.setupWith(title: feedItem.title, description: feedItem.description)
      cell.itemImageView.image = UIImage(named: "image-placeholder")
      if let imageUrl = feedItem.imageUrl {
         Nuke.loadImage(with: imageUrl, into: cell.itemImageView)
      }
      
      return cell
   }
}

// MARK: -
// MARK: UITableViewDelegate
// --------------------
extension MainViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let feedItem = feedItems[indexPath.row]
      
      let detailVC = storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
      detailVC.feedItem = feedItem
      self.present(detailVC, animated: true, completion: nil)
      
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

