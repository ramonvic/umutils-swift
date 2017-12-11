//
//  UIControl+Rx.swift
//  Pods
//
//  Created by Ramon Vicente on 21/03/17.
//
//

import UIKit
import RxCocoa
import RxSwift

public extension UIControl {
     static func valuePublic<T, ControlType: UIControl>(_ control: ControlType,
                                                        getter:  @escaping (ControlType) -> T,
                                                        setter: @escaping (ControlType, T) -> ()) -> ControlProperty<T> {
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let existingSelf = control else {
                return Observable.empty()
            }

            return (existingSelf as UIControl).rx.controlEvent([.allEditingEvents, .valueChanged])
                .flatMap { _ in
                    return control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        return ControlProperty(values: values, valueSink: Binder(control) { control, value in
            setter(control, value)
        })
    }
}
