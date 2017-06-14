//
//  FeedParser.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation
import FeedKit

protocol FeedItemParser {

   /**
    Note for this implementation:
    If we wanted to decouple the implementation of the parser from the 3rd party library FeedKit,
    we should use a dictionary instead of RSSFeedItem, and define a struct for the keys used 
    on each property. 
   */
   
   /// Parses an RSS feed item into the custom feed item class
   func feedItemFrom(_ rssFeedItem: RSSFeedItem) -> FeedItem?
}

extension FeedItemParser {
   
   func feedItemFrom(_ rssFeedItem: RSSFeedItem) -> FeedItem? {
      guard let title = rssFeedItem.title,
         let externalUrlString = rssFeedItem.link,
         let externalUrl = URL(string: externalUrlString)
         else { return nil }
      
      var feedItem = FeedItem(title: title, externalUrl: externalUrl)
      if let description = rssFeedItem.description {
         feedItem.description = description
      }
      if let content = rssFeedItem.content?.contentEncoded,
         let imageUrl = imageUrlFrom(content) {
         feedItem.imageUrl = imageUrl
      }
      
      return feedItem
   }
   
   private func imageUrlFrom(_ string: String) -> URL? {
      let urlRegex = "(?<=img src=\").*?(?=\")"
      
      let matches = Regex.matches(for: urlRegex, in: string)
      guard !matches.isEmpty,
         let url = URL(string: matches.first!) else { return nil }
      
      return url
   }
}
