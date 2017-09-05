//
//  ViewModelBindable.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

import Foundation

public protocol ViewModelBindable: class {
    
    associatedtype ViewModel: AnyObject
    
    var viewModel: ViewModel? { get set }
    
    func bindViewModel(viewModel: ViewModel)
}

extension ViewModelBindable where Self: AnyObject {
    
    public var viewModel: ViewModel? {
        
        get {
            return getAssociatedObject(object: self, key: &AssociatedKey)
        }
        
        set(newViewModel) {
            if let viewModel = newViewModel {
                setAssociatedObject(object: self, value: viewModel, key:
                    &AssociatedKey, policy:
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
                registerBinding(viewModel: viewModel)
            }
        }
    }
    
    private func registerBinding(viewModel: ViewModel) {
        bindViewModel(viewModel: viewModel)
    }
    
}
