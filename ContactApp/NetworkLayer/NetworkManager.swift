//
//  NetworkManager.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import Reachability
import CoreTelephony

public let keyNetworkType       = "keyNetworkType"
public let keyConnectionType    = "keyConnectionType"

enum NetworkType {
    case unknown, unavailable, slow, fast
    
    init(_ radioTechnology:String) {
        switch radioTechnology {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            self = .slow
        default:
            self = .fast
        }
    }
}

enum ConnectionType {
    case unknown, unavailable, gprs, edge, wcdma, hsdpa, hsupa, cdma1x, cdmaEVDORev0, cdmaEVDORevA, cdmaVDORevB, hrpd, lte, wifi
    
    init(_ radioTechnology:String) {
        switch radioTechnology {
        case CTRadioAccessTechnologyGPRS: self = .gprs
        case CTRadioAccessTechnologyEdge: self = .edge
        case CTRadioAccessTechnologyWCDMA: self = .wcdma
        case CTRadioAccessTechnologyHSDPA: self = .hsdpa
        case CTRadioAccessTechnologyHSUPA: self = .hsupa
        case CTRadioAccessTechnologyCDMA1x: self = .cdma1x
        case CTRadioAccessTechnologyCDMAEVDORev0: self = .cdmaEVDORev0
        case CTRadioAccessTechnologyCDMAEVDORevA: self = .cdmaEVDORevA
        case CTRadioAccessTechnologyCDMAEVDORevB: self = .cdmaVDORevB
        case CTRadioAccessTechnologyeHRPD: self = .hrpd
        case CTRadioAccessTechnologyLTE: self = .lte
        default: self = .unknown
        }
    }
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    var isNetworkAvailable = true
    var isWifiNetwork = true
    var is3GNetwork = false
    var is2GNetwork = false
    
    private var observerStarted = false
    private var telephonyInfo = CTTelephonyNetworkInfo()
    private var internetReachability = Reachability()
    
    private override init() {
        super.init()
        startObserver()
        saveSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postWWANNotification), name: .CTRadioAccessTechnologyDidChange, object: nil)
    }
    
    private func saveSettings() {
        isNetworkAvailable = false
        isWifiNetwork = false
        is3GNetwork = false
        is2GNetwork = false
        
        if let network = internetReachability?.connection {
            switch network {
            case .none: break
            case .wifi:
                isNetworkAvailable = true
                isWifiNetwork = true
            case .cellular:
                isNetworkAvailable = true
                if let telephonyInfo = CTTelephonyNetworkInfo().currentRadioAccessTechnology {
                    if isFast(telephonyInfo) {
                        is3GNetwork = true
                    } else {
                        is2GNetwork = true
                    }
                }
            }
        }
    }
    
    private func isFast(_ radioTechnology:String) -> Bool {
        return !([CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x].contains(radioTechnology))
    }
    
    @objc private func applicationWillEnterForeground() {
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.saveSettings()
        }
    }
    
    @objc private func reachabilityChanged(_ notification:Notification) {
        if let currentReachability  = notification.object as? Reachability {
            updateInterface(withReachability: currentReachability)
        }
    }
    
    private func updateInterface(withReachability reachability:Reachability) {
        switch reachability.connection {
        case .none:
            NotificationCenter.default.post(name: .ReachabilityChangedNetwork, object: nil, userInfo: [keyNetworkType : NetworkType.unavailable])
            NotificationCenter.default.post(name: .ReachabilityChangedConnection, object: nil, userInfo: [keyConnectionType : ConnectionType.unavailable])
        case .wifi:
            NotificationCenter.default.post(name: .ReachabilityChangedNetwork, object: nil, userInfo: [keyNetworkType : NetworkType.fast])
            NotificationCenter.default.post(name: .ReachabilityChangedConnection, object: nil, userInfo: [keyConnectionType : ConnectionType.wifi])
        case .cellular:
            postWWANNotification()
        }
        
        saveSettings()
        NotificationCenter.default.post(name: .NetworkChanged, object: nil)
    }
    
    @objc private func postWWANNotification() {
        if let radioTechnology = telephonyInfo.currentRadioAccessTechnology {
            NotificationCenter.default.post(name: .ReachabilityChangedNetwork, object: nil, userInfo: [keyNetworkType : NetworkType(radioTechnology)])
            NotificationCenter.default.post(name: .ReachabilityChangedConnection, object: nil, userInfo: [keyConnectionType : ConnectionType(radioTechnology)])
        }
    }
    
    private func startObserver() {
        if !observerStarted {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: nil)
            try? internetReachability?.startNotifier()
            // Fecth the current reachablity status
            if let currentReachability = internetReachability {
                updateInterface(withReachability: currentReachability)
            }
            observerStarted = true
        }
    }
    
    private func stopObserver() {
        internetReachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        observerStarted = false
    }
}

extension Notification.Name {
    public static let NetworkChanged = Notification.Name("NetworkChanged")
    public static let ReachabilityChangedNetwork = Notification.Name("ReachabilityChangedNetwork")
    public static let ReachabilityChangedConnection = Notification.Name("ReachabilityChangedConnection")
}
