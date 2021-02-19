//
//  EventTrackingProxy.swift
//  DMSLAnalytics
//
//  Created by Dmytro Shulzhenko on 18.10.2020.
//

import UIKit

public protocol EventTrackingProxy {
    func track(application: UIApplication,
               didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?)
    func trackBecomeActive()
    func track(event: Event)
    func update(userProperties: [String: NSObject])
    func update(userId: String)
}
