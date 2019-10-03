//
//  AssociatedObjects.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

public var AssociatedKey: UInt = 0

public final class AssociatedObjectBox<T> {
    let value: T
    
    init(_ x: T) {
        value = x
    }
}

public func lift<T>(x: T) -> AssociatedObjectBox<T> {
    return AssociatedObjectBox(x)
}

public func setAssociatedObject<T>(object: AnyObject, value: T, key: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    objc_setAssociatedObject(object, key, value,  policy)
}

public func getLazyObject<T>(object: AnyObject, key: UnsafeRawPointer, loader handler: (() -> T)) -> T {
    if let t: T = getAssociatedObject(object: object, key: key) {
        return t
    }
    
    let t = handler()
    setAssociatedObject(object: object, value: t, key: key, policy: .OBJC_ASSOCIATION_RETAIN)
    return t
}

public func getAssociatedObject<T>(object: AnyObject, key: UnsafeRawPointer) -> T? {
    if let v = objc_getAssociatedObject(object, key) as? T {
        return v
    } else if let v = objc_getAssociatedObject(object, key) as? AssociatedObjectBox<T> {
        return v.value
    } else {
        return nil
    }
}

public func getLazyObject<T>(object: AnyObject, key: UnsafeRawPointer, loader handler: (() -> T)) -> T {
    if let t: T = getAssociatedObject(object: object, key: key) {
        return t
    }
    
    let t = handler()
    setAssociatedObject(object: object, value: t, key: key, policy: .OBJC_ASSOCIATION_RETAIN)
    return t
}
