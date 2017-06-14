//
//  FeedReader.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation
import FeedKit

typealias FeedReaderResult = (_ feedTitle: String?, _ items: [FeedItem]?, _ error: FeedReaderError?) -> ()

protocol FeedReader {
   
   var itemParser: FeedItemParser { get }
   
   /**
    Reads data from the url asynchronously.
    
    The result is called with the following optional parameters
    - feedTitle: The title of the RSS feed or nil in case of error
    - items: The array of feed items or nil in case of error
    - error: The error object in case of failure
    
    - parameter rssFeedUrl: The URL of the RSS Feed
    - parameter completion: The FeedReaderResult completion handler called once the response was processed.
   */
   func fetchFeedItems(from rssFeedUrl: URL, completion: @escaping FeedReaderResult)
}

extension FeedReader {
   
   func fetchFeedItems(from rssFeedUrl: URL, completion: @escaping FeedReaderResult) {
      guard let rssFeedParser = FeedParser(URL: rssFeedUrl) else {
         completion(nil, nil, .invalidUrl)
         return
      }
      
      rssFeedParser.parseAsync() { result in
         guard let feed = result.rssFeed,
            result.isSuccess else {
               if let error = result.error {
                  let readerError = FeedReaderError.requestError(code: error.code, message: error.localizedDescription)
                  completion(nil, nil, readerError)
               } else {
                  completion(nil, nil, .unknown)
               }
               return
         }
         let feedTitle = feed.title
         guard let rssItems = feed.items,
            !rssItems.isEmpty else {
               completion(feedTitle, nil, nil)
               return
         }
         
         var feedItems = [FeedItem]()
         rssItems.forEach { rssFeedItem in
            if let feedItem = self.itemParser.feedItemFrom(rssFeedItem) {
               feedItems.append(feedItem)
            }
         }
         completion(feedTitle, feedItems, nil)
      }
   }
}
