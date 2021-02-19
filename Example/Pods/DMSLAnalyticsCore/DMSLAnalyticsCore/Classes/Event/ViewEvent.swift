//
//  ViewEvent.swift
//  DMSL-Analytics
//
//  Created by Dmytro Shulzhenko on 17.10.2020.
//

import Foundation

public struct ViewEvent: ParamsContainer {
    public let name: String
    public let context: Event.Context
    public var params: [String: Any]
    public let isActive: Bool
    public let isUrgent: Bool
    
    public init(context: Event.Context,
                params: [String: Any] = [:],
                isActive: Bool = true,
                isUrgent: Bool = false) {
        self.init(name: context.rawValue,
                  context: context,
                  params: params,
                  isActive: isActive,
                  isUrgent: isUrgent)
    }
    
    public init(name: String,
                context: Event.Context,
                params: [String: Any] = [:],
                isActive: Bool = true,
                isUrgent: Bool = false) {
        self.name = "\(name)_view"
        self.context = context
        self.params = params
        self.isActive = isActive
        self.isUrgent = isUrgent
    }
}
