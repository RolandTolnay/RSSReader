//
//  HistoryManager.swift
//  RSSReader
//
//  Created by Roland Tolnay on 14/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

typealias History = [HistoryItem]

class HistoryManager {
   
   static let shared = HistoryManager()
   
   private init() {
      if let saved = savedHistory() {
         internalHistory = saved
      } else {
         internalHistory = defaultHistory
         persistHistory(internalHistory)
      }
   }
   
   var history: History {
      return internalHistory
   }
   
   /// Adds a new item to the history if not already saved.
   func addNewItem(title: String, url: URL) {
      let historyItem = HistoryItem(title: title, url: url)
      if !internalHistory.contains(historyItem) {
         internalHistory.append(historyItem)
         persistHistory(internalHistory)
      }
   }
   
   private var internalHistory = History()
   
   private var defaultHistory: History {
      var history = History()
      
      let trailers = HistoryItem(title: "Latest Movie Trailers",
                                 url: URL(string: "https://trailers.apple.com/trailers/home/rss/newtrailers.rss")!)
      let developerNews = HistoryItem(title: "News and Updates - Apple Developer",
                                      url: URL(string: "https://developer.apple.com/news/rss/news.rss")!)
      let newsRoom = HistoryItem(title: "Apple News Room",
                                 url: URL(string: "https://www.apple.com/newsroom/rss-feed.rss")!)
      let topMovies = HistoryItem(title: "iTunes Store: Top Movies",
                                  url: URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/xml")!)
      let topFreeApps = HistoryItem(title: "iTunes Store: Top Free Apps",
                                    url: URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topfreeapplications/limit=25/xml")!)
      history.append(trailers)
      history.append(developerNews)
      history.append(newsRoom)
      history.append(topMovies)
      history.append(topFreeApps)
      
      return history
   }
}

fileprivate extension HistoryManager {
   
   private var defaults: UserDefaults {
      return UserDefaults.standard
   }
   
   private struct HistoryKey {
      static let urlStrings = "historyItemUrlStrings"
      static let titleStrings = "historyItemTitleStrings"
   }
   
   fileprivate func savedHistory() -> History? {
      guard let titleStrings = defaults.array(forKey: HistoryKey.titleStrings) as? [String],
         let urlStrings = defaults.array(forKey: HistoryKey.urlStrings) as? [String],
         titleStrings.count == urlStrings.count else { return nil }
      
      var savedHistory = History()
      for (index, title) in titleStrings.enumerated() {
         if let url = URL(string: urlStrings[index]) {
            let item = HistoryItem(title: title, url: url)
            savedHistory.append(item)
         }
      }
      
      return savedHistory
   }
   
   fileprivate func persistHistory(_ history: History) {
      let titleStrings = history.map { $0.title }
      let urlStrings = history.map { $0.url.absoluteString }
      defaults.set(titleStrings, forKey: HistoryKey.titleStrings)
      defaults.set(urlStrings, forKey: HistoryKey.urlStrings)
      defaults.synchronize()
   }
}
