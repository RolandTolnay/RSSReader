//
//  FeedItemManager.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

struct FeedItemManager { }

extension FeedItemManager: FeedItemParser { }

extension FeedItemManager: FeedReader {
   
   var itemParser: FeedItemParser {
      return self
   }
}
