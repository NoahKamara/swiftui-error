//
//  File.swift
//  
//
//  Created by Noah Kamara on 16.02.24.
//

import SwiftUI
import Foundation

fileprivate struct ErrorReceivingModifier<E: Error>: ViewModifier {
    @Environment(\.internalErrorHandling)
    var parentSubject
    
    let childSubject = ErrorHandling(subject: .init())
    var action: (E) -> Void
    
    init(action: @escaping (E) -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.internalErrorHandling, childSubject)
            .onReceive(childSubject, perform: { error in
                if let error = error as? E {
                    action(error)
                } else {
                    parentSubject.push(error)
                }
            })
    }
}

public extension View {
    /// Associates a closure with an error type and performs `action` when 
    /// this view catches an error thrown by a descendent
    ///
    ///
    /// Add this view modifer to a view to set the closure the Environment calls when presenting
    /// a particular kind of error. Use ``SwiftUIError/EnvironmentError/push`` to
    /// throw an error.
    ///
    /// For example, you can log when a `FooError` is thrown like so:
    ///
    ///     var body: some View {
    ///         Button(action: {}) {
    ///
    ///         }
    ///         .onCatch(of: FooError.self) { error in
    ///             print("Caught 'FooError':", error)
    ///         }
    ///     }
    ///
    ///
    /// - Parameters:
    ///   - error: The type of error this closure catches
    ///   - action: The action to perform when an `error` is
    ///     emitted by a descendant. The `error` emitted by publisher is
    ///     passed as a parameter to `action`.
    ///
    /// - Returns: A view that triggers `action` when a descendant emits an `error`.
    func onCatch<E: Error>(
        of error: E.Type = E.self,
        perform action: @escaping (E) -> Void
    ) -> some View {
        self.modifier(ErrorReceivingModifier(action: action))
    }
    
    func onCatch(
        perform action: @escaping (any Error) -> Void
    ) -> some View {
        self.modifier(ErrorReceivingModifier<any Error>(action: action))
    }
}
