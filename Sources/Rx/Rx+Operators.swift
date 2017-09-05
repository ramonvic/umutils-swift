//
//  RxOperators.swift
//  SPA at home
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - isSucceeded()

extension ObservableType {
  public func isSucceeded() -> Observable<Bool> {
    return self.map(true).catchErrorJustReturn(false)
  }
}


// MARK: - map()

extension ObservableType {
  public func map<T>(_ element: T) -> Observable<T> {
    return self.map { _ in element }
  }
}

extension SharedSequence {
  public func map<T>(_ element: T) -> SharedSequence<SharingStrategy, T> {
    return self.map { _ in element }
  }
}


// MARK: - mapVoid()

extension ObservableType {
  public func mapVoid() -> Observable<Void> {
    return self.map(Void())
  }
}

extension SharedSequence {
  public func mapVoid() -> SharedSequence<SharingStrategy, Void> {
    return self.map(Void())
  }
}


// MARK: - ignoreErrors()

extension ObservableType {
  public func ignoreErrors() -> Observable<E> {
    return self.catchError { error -> Observable<E> in
      return .empty()
    }
  }
}


// MARK: - catchError()

extension ObservableType {
  public func catchError<O: ObserverType>(_ observer: O) -> Observable<E> where O.E == Swift.Error {
    return self.catchError { error in
      observer.onNext(error)
      return .empty()
    }
  }
}

infix operator <->

@discardableResult public func <-><T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)
    
    let propertyToVariable = property
        .subscribe(
            onNext: { variable.value = $0 },
            onCompleted: { variableToProperty.dispose() }
    )
    
    return Disposables.create(variableToProperty, propertyToVariable)
}
