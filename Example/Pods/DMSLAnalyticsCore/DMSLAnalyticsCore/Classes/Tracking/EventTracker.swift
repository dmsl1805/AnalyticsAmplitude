//
//  EventTracker.swift
//  Pods
//
//  Created by Dmytro Shulzhenko on 17.10.2020.
//

import UIKit

public protocol EventTracking {
    var currentContext: Event.Context { get set }
    
    func setTrackers(_ trackers: EventTrackingProxy...)
    
    func track(application: UIApplication,
                      didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?)
    
    func trackBecomeActive()
        
    func trackView(_ event: ViewEvent, persistContext: Bool, overrideContext: Bool)
    
    func trackAction(_ event: ActionEvent)
    
    func update(userProperties: [String : NSObject])
    
    func update(userId: String)
}

public final class EventTracker: EventTracking {
    private let lock = NSRecursiveLock()
    private var trackers: [EventTrackingProxy] = []
    private var _currentContext: Event.Context?
    public var currentContext: Event.Context {
        get { _currentContext ?? .initial }
        set { lock.lock(); defer { lock.unlock() }; _currentContext = newValue }
    }
    
    public func setTrackers(_ trackers: EventTrackingProxy...) {
        self.trackers = trackers
    }
    
    public func track(application: UIApplication,
                      didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?) {
        trackers.forEach {
            $0.track(application: application, didFinishLaunchingWithOptions: options)
        }
    }
    
    public func trackBecomeActive() {
        trackers.forEach {
            $0.trackBecomeActive()
        }
    }
    
    public func trackView(_ event: ViewEvent, persistContext: Bool, overrideContext: Bool) {
        track(self.event(view: event, overrideContext: overrideContext))
        
        if persistContext {
            currentContext = event.context
        }
    }
    
    public func trackAction(_ event: ActionEvent) {
        track(self.event(action: event))
    }
    
    public func update(userProperties: [String : NSObject]) {
        trackers.forEach {
            $0.update(userProperties: userProperties)
        }
    }
    
    public func update(userId: String) {
        trackers.forEach {
            $0.update(userId: userId)
        }
    }
    
    private func track(_ event: Event) {
        trackers.forEach {
            $0.track(event: event)
        }
    }
    
    private func event(action event: ActionEvent) -> Event {
        Event(name: event.name,
              context: currentContext,
              params: event.params,
              isActive: event.isActive,
              isUrgent: event.isUrgent)
    }
    
    private func event(view event: ViewEvent, overrideContext: Bool) -> Event {
        Event(name: event.name,
              context: overrideContext ? event.context : currentContext,
              params: event.params,
              isActive: event.isActive,
              isUrgent: event.isUrgent)
    }
}

public extension EventTracker {
    internal(set) static var `default`: EventTracking = EventTracker()
}
