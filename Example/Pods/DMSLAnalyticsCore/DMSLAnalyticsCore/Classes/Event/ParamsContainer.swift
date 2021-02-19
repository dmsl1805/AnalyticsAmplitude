//
//  ParamsContainer.swift
//  DMSLAnalytics
//
//  Created by Dmytro Shulzhenko on 18.10.2020.
//

import Foundation

public protocol ParamsContainer {
    var params: [String: Any] { get set }
}

extension ParamsContainer {
    public func params(_ params: [String: Any]) -> Self {
        var container = self
        container.params = container.params.merging(params) { _, new in new }
        return container
    }
    
    public func param(_ key: String, value: Any) -> Self {
        params([key: value])
    }
    
    public func error(_ error: NSError) -> Self {
        self.error(code: error.code)
    }
    
    public func error(code: Int) -> Self {
        params(["error_code": code])
    }
}
