//
//  ViewModelBindable.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

import Foundation

public protocol ViewModelBindable: class {
    
    associatedtype Model: ViewModel
    
    var viewModel: Model? { get set }
    
    func bindViewModel(viewModel: Model)
}

extension ViewModelBindable {
    
    public var viewModel: Model? {
        
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
    
    private func registerBinding(viewModel: Model) {
        bindViewModel(viewModel: viewModel)
    }
    
}
