//
//  AmplitudeEventTracker.swift
//  DMSL-Analytics
//
//  Created by Dmytro Shulzhenko on 15.10.2020.
//

import Foundation
import Amplitude
import DMSLAnalyticsCore

public final class AmplitudeTracker: EventTrackingProxy {
    private let client: Amplitude
    
    public init(custom: (name: String, url: String)? = nil,
                apiKey: String,
                eventUploadThreshold: Int32 = 3,
                eventUploadPeriodSeconds: Int32 = 5) {
        client = custom.map { Amplitude.instance(withName: $0.name) } ?? .instance()!
        custom.map { client.setServerUrl($0.url) }
        client.initializeApiKey(apiKey)
        client.eventUploadThreshold = eventUploadThreshold
        client.eventUploadPeriodSeconds = eventUploadPeriodSeconds
    }
    
    public func trackBecomeActive() { }
    
    public func track(application: UIApplication,
                      didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?) { }
    
    public func track(event: Event) {
        client.logEvent(event.name,
                        withEventProperties: event.params,
                        outOfSession: !event.isActive)
        
        if event.isUrgent {
            client.uploadEvents()
        }
    }
    
    public func update(userProperties: [String : NSObject]) {
        client.identify(
            userProperties.reduce(AMPIdentify()) { identify, data in
                identify.set(data.key, value: data.value)
            }
        )
    }
    
    public func update(userId: String) {
        client.setUserId(userId)
    }
}

