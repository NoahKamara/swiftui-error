//
//  File.swift
//  
//
//  Created by Noah Kamara on 16.02.24.
//

import Foundation
import Combine
import OSLog

/// A publisher that can be used to publish errors up the view hierarchy
public class ErrorHandling: Publisher {
    public typealias Output = any Error
    public typealias Failure = Never
    typealias Subject = PassthroughSubject<any Error,Never>
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Error == S.Input {
        if let subject {
            subject.receive(subscriber: subscriber)
        } else {
            runtimeWarn("Subscription not possible, no subject")
        }
    }
    
    private let subject: Subject?
    
    internal init(subject: Subject?) {
        self.subject = subject
    }
    
    /// Publishes an error upstream
    /// - Parameter error: an error
    public func push<E: Error>(_ error: E) {
        guard let subject else {
            runtimeWarn("Cannot push error \(error)")
            return
        }
        subject.send(error)
    }
}


public class RootErrorHandling: ErrorHandling {
    init() {
        super.init(subject: nil)
    }
    
    /// Publishes an error upstream
    /// - Parameter error: an error
    public override func push<E: Error>(_ error: E) {
        runtimeWarn("Error of \(String(describing: E.self)) was not caught: \(error)")
    }
}

import SwiftUI

private struct ErrorHandlingEnvironmentKey: EnvironmentKey {
    static var defaultValue: ErrorHandling = RootErrorHandling()
}

extension EnvironmentValues {
    public var errorHandling: ErrorHandling {
        self[ErrorHandlingEnvironmentKey.self]
    }
    
    internal var internalErrorHandling: ErrorHandling {
        get { self[ErrorHandlingEnvironmentKey.self] }
        set { self[ErrorHandlingEnvironmentKey.self] = newValue }
    }
}

