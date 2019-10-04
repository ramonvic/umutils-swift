//
//  UIView+Rx.swift
//  UMUtils
//
//  Created by brennobemoura on 20/04/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate extension UIView {
    @objc func onTap(_ sender: TapGesture) {
        sender.handler()
    }
}

public class TapGesture: UITapGestureRecognizer {
    let handler: () -> Void

    init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.onTap(_:)))
    }
}

public extension Reactive where Base: UIView {
    var tap: ControlEvent<Void> {
        let observer: PublishRelay<Void> = .init()
        self.base.addGestureRecognizer(TapGesture(target: self.base) {
            observer.accept(())
        })
        
        return ControlEvent(events: observer)
    }
}
