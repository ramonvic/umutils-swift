//
//  NSAttributedString+HTMLString.swift
//  SPA at home
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import UIKit

enum HTMLStringError: Error {
  case invalidData
  case underlying(Error)
}

public extension NSAttributedString {
  convenience init(
    htmlString: String,
    fontFamily: String = "-apple-system",
    fontSize: CGFloat = UIFont.systemFontSize
  ) throws {
    let styleTagString = NSAttributedString.styleForFont(family: fontFamily, size: fontSize)
    let htmlString = styleTagString + htmlString
    guard let data = htmlString.data(using: .utf8) else { throw HTMLStringError.invalidData }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
    ]
    do {
      try self.init(data: data, options: options, documentAttributes: nil)
    } catch let error {
      throw HTMLStringError.underlying(error)
    }
  }

  private class func styleForFont(family: String, size: CGFloat) -> String {
    return "<style>body{font-family: '\(family)', -apple-system, sans-serif;font-size: \(size)px;}</style>"
  }
}
