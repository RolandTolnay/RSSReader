//
//  FeedUrlStorage.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

fileprivate let defaultRssUrlString = "https://trailers.apple.com/trailers/home/rss/newtrailers.rss"

fileprivate let rssUrlStringKey = "rssUrlString"

class FeedUrlStorage {
   
   static let shared = FeedUrlStorage()
   private init() { }
   
   var rssUrl: URL {
      guard let saved = loadSavedUrl() else {
         let url = URL(string: defaultRssUrlString)!
         saveUrl(url)
         return url
      }
      
      return saved
   }
   
   /// Sets and saves the url to persistance
   func saveUrl(_ url: URL) {
      let urlString = url.absoluteString
      UserDefaults.standard.set(urlString, forKey: rssUrlStringKey)
      UserDefaults.standard.synchronize()
   }
   
   private func loadSavedUrl() -> URL? {
      guard let urlString = UserDefaults.standard.string(forKey: rssUrlStringKey),
         let url = URL(string: urlString) else { return nil }
      
      return url
   }
}
