//
//  MBProgressHUD+Rx.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//


import RxSwift
import RxCocoa
import MBProgressHUD

private var MBProgressHUDAttachedViewKey: UInt8 = 0

extension Reactive where Base: MBProgressHUD {
    
    public var animating: AnyObserver<Bool> {
        return AnyObserver {event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                if self.base.attachedView == nil {
                    self.base.attachedView = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
                }
                if self.base.attachedView != nil {
                    
                    if value {
                        let loadingNotification = MBProgressHUD.showAdded(to: self.base.attachedView!, animated: true)
                        loadingNotification.mode = self.base.mode
                        loadingNotification.label.text = self.base.label.text
                        loadingNotification.backgroundView.style = self.base.backgroundView.style
                    } else {
                        MBProgressHUD.hide(for: self.base.attachedView!, animated: true)
                    }
                }
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                #if DEBUG
                    fatalError(error)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
}

extension MBProgressHUD {
    
    public static var rx: Reactive<MBProgressHUD>.Type {
        get {
            return Reactive<MBProgressHUD>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    var attachedView: UIView? {
        get {
            return objc_getAssociatedObject(self, &MBProgressHUDAttachedViewKey) as? UIView
        }
        set(value) {
            objc_setAssociatedObject(self, &MBProgressHUDAttachedViewKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
