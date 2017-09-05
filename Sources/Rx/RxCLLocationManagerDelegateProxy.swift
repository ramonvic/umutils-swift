//
//  RxCLLocationManagerDelegateProxy.swift
//  Pods
//
//  Created by Ramon Vicente on 24/03/17.
//
//

import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class RxCLLocationManagerDelegateProxy : DelegateProxy
    , CLLocationManagerDelegate
, DelegateProxyType {
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let locationManager: CLLocationManager = object as! CLLocationManager
        return locationManager.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CLLocationManager = object as! CLLocationManager
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
}
