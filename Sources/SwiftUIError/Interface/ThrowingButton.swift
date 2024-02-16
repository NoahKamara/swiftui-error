//
//  SwiftUIView.swift
//  
//
//  Created by Noah Kamara on 16.02.24.
//

import SwiftUI

/// A control that initiates a throwing action.
///
/// You create a throwing button by providing an action and a label. The action is either
/// a method or closure property that does something when a user clicks or taps
/// the button. The label is a view that describes the button's action --- for
/// example, by showing text, an icon, or both.
///
/// > This is an implementation of SwiftUI's `Button` that takes a throwing action
///
public struct ThrowingButton<Label: View>: View {
    @Environment(\.errorHandling)
    private var errors
    
    private let action: () throws -> Void
    private let label: Label
    
    /// Creates a throwing button that displays a custom label.
    ///
    /// - Parameters:
    ///   - action: The action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    init(action: @escaping () throws -> Void, label: Label) {
        self.action = action
        self.label = label
    }
    
    
    /// Creates a throwing button that displays a custom label.
    ///
    /// - Parameters:
    ///   - action: The action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    public init(action: @escaping () throws -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    @MainActor
    public var body: some View {
        Button<Label>(action: {
            do {
                try action()
            } catch {
                errors.push(error)
            }
        }, label: {
            label
        })
    }
}

extension ThrowingButton where Label == Text {
    /// Creates a throwing button that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `action`.
    ///   - action: The action to perform when the user triggers the button.
    public init(_ titleKey: LocalizedStringKey, action: @escaping () throws -> Void) {
        self.init(action: action, label: Text(titleKey))
    }
    
    /// Creates a throwing button that generates its label from a string.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - action: The action to perform when the user triggers the button.
    public init<S>(_ title: S, action: @escaping () throws -> Void) where S : StringProtocol {
        self.init(action: action, label: Text(title))
    }
}


#Preview {
    VStack {
        ThrowingButton("Hello World") {
            throw URLError(.cancelled)
        }
        
        ThrowingButton(String("Hello World")) {
            throw URLError(.cancelled)
        }
        
        ThrowingButton(action: { throw URLError(.cancelled) }) {
            Text("Hello World")
        }
    }
    .onCatch(of: URLError.self) { error in
        print("thrown", error)
    }
}
