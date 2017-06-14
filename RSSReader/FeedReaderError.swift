//
//  FeedReaderError.swift
//  RSSReader
//
//  Created by Roland Tolnay on 13/06/2017.
//  Copyright © 2017 Roland Tolnay. All rights reserved.
//

import Foundation

/**
 RSS feed reader error
 
 - invalidUrl: The url provided for the RSS feed was invalid
 - requestError: Something went wrong while connecting to the RSS feed. Refer to code and message for details.
 - unknown: An unknown error
 */
enum FeedReaderError: Error {
   case invalidUrl
   case requestError(code: Int, message: String)
   case unknown
}

extension FeedReaderError: LocalizedError {
   
   var errorDescription: String? {
      switch self {
      case .invalidUrl:
         return "The URL provided for the RSS feed was invalid"
      case .requestError(code: let code, message: let message):
         return "\(message) - code: \(code)"
      case .unknown:
         return "An unknown error occured. Please try again later"
      }
   }
}
