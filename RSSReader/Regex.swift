//
//  Regex.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

class Regex {
   
   static func matches(for regex: String, in text: String) -> [String] {
      do {
         let regex = try NSRegularExpression(pattern: regex)
         let nsString = text as NSString
         let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
         return results.map { nsString.substring(with: $0.range)}
      } catch let error {
         print("invalid regex: \(error.localizedDescription)")
         return []
      }
   }
}
