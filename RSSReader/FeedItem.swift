//
//  NewsItem.swift
//  RSSReader
//
//  Created by Roland Tolnay on 6/13/17.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

struct FeedItem {
   
   /// The title of the item
   var title: String
   /// The url pointing to an external website for the item
   var externalUrl: URL
   
   /// A detailed description of the item if available
   var description: String?
   /// The url of an associated image to the item if available
   var imageUrl: URL?
   
   init(title: String, externalUrl: URL, description: String? = nil, imageUrl: URL? = nil) {
      self.title = title
      self.externalUrl = externalUrl
      self.description = description
      self.imageUrl = imageUrl
   }
}
