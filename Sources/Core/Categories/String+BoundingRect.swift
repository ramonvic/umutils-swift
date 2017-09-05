//
//  String+BoundingRect.swift
//  Umobi
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import UIKit

public extension String {

  public func boundingRect(with size: CGSize, attributes: [String: Any]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return rect
  }

  public func size(thatFits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
    let attributes = [NSFontAttributeName: font]
    var size = self.boundingRect(with: size, attributes: attributes).size
    if maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    return size
  }

  public func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
  }

  public func height(thatFitsWidth width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
  }

}
