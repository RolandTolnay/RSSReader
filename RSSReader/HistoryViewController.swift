//
//  HistoryViewController.swift
//  RSSReader
//
//  Created by Roland Tolnay on 14/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
   
   var delegate: HistorySelectionListener?
   
   fileprivate var history = History()
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      history = HistoryManager.shared.history
   }
}

extension HistoryViewController {
   
   struct HistoryItemCell {
      static var identifier: String {
         return String(describing: self)
      }
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return history.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: HistoryItemCell.identifier, for: indexPath)
      let historyItem = history[indexPath.row]
      
      cell.textLabel?.text = historyItem.title
      cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
      
      return cell
   }
}

extension HistoryViewController {
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let historyItem = history[indexPath.row]
      
      delegate?.didSelectHistoryItem(historyItem)
      tableView.deselectRow(at: indexPath, animated: true)
      self.navigationController?.dismiss(animated: true, completion: nil)
   }
}

protocol HistorySelectionListener {
   
   func didSelectHistoryItem(_ historyItem: HistoryItem)
}
