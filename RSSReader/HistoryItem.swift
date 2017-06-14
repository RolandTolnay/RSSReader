//
//  HistoryItem.swift
//  RSSReader
//
//  Created by Roland Tolnay on 14/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

struct HistoryItem: Equatable {
   
   var title: String
   var url: URL
}

func ==(lhs: HistoryItem, rhs: HistoryItem) -> Bool {
   return lhs.title == rhs.title && lhs.url == rhs.url
}
