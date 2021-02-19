//
//  Event.swift
//  DMSL-Analytics
//
//  Created by Dmytro Shulzhenko on 15.10.2020.
//

import Foundation
import Tagged

public struct Event {
    enum Key: String {
        case context
    }
    
    public typealias Context = Tagged<Self, String>

    public let name: String
    private (set) var params: [String: Any]
    public let isActive: Bool
    public let isUrgent: Bool
    
    init(name: String,
         context: Context,
         params: [String: Any] = [:],
         isActive: Bool = true,
         isUrgent: Bool) {
        self.name = name
        self.params = params
        self.isActive = isActive
        self.isUrgent = isUrgent
        
        self.params[Key.context.rawValue] = context.rawValue
    }
}

extension Event.Context {
    public static let initial: Self = "initial"
}
