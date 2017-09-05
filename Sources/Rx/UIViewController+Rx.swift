//
//  UIViewController+Rx.swift
//  SPA at home
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {

  var viewDidLoad: Observable<Void> {
    return self.sentMessage(#selector(Base.viewDidLoad)).map { _ in Void() }
  }

  var viewWillAppear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
  }
  var viewDidAppear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
  }

  var viewWillDisappear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
  }
  var viewDidDisappear: Observable<Bool> {
    return self.sentMessage(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
  }

  var viewWillLayoutSubviews: Observable<Void> {
    return self.sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in Void() }
  }
  var viewDidLayoutSubviews: Observable<Void> {
    return self.sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in Void() }
  }

}
