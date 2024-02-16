//
//  File.swift
//
//
//  Created by Noah Kamara on 16.02.24.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
fileprivate struct ErrorAlertModifier<E: Error, Message: View, Actions: View>: ViewModifier {
    @State
    var error: E? = nil
    
    let titleKey: LocalizedStringKey
    let actions: (E) -> Actions
    let message: (E) -> Message
    
    init(
        titleKey: LocalizedStringKey,
        actions: @escaping (E) -> Actions,
        message: @escaping (E) -> Message
    ) {
        self.titleKey = titleKey
        self.actions = actions
        self.message = message
    }
    
    func body(content: Content) -> some View {
        content
            .onCatch(of: E.self, perform: { error in
                self.error = error
            })
            .alert(
                titleKey,
                isPresented: $error.isPresent(),
                presenting: error,
                actions: actions,
                message: message
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func alert<E: Error, Actions: View, Message: View>(
        _ titleKey: LocalizedStringKey,
        for type: E.Type = E.self,
        @ViewBuilder
        actions: @escaping (E) -> Actions,
        @ViewBuilder
        message: @escaping (E) -> Message
    ) -> some View {
        self.modifier(
            ErrorAlertModifier(
                titleKey: titleKey,
                actions: actions,
                message: message
            )
        )
    }
    
    func alert<E: Error, Message: View>(
        _ titleKey: LocalizedStringKey,
        for type: E.Type = E.self,
        @ViewBuilder
        message: @escaping (E) -> Message
    ) -> some View {
        self.modifier(
            ErrorAlertModifier(
                titleKey: titleKey,
                actions: { _ in EmptyView() },
                message: message
            )
        )
    }
}



#Preview {
    if #available(iOS 15.0, *) {
        ThrowingButton("Throw") {
            throw URLError(.cancelled)
        }
        .alert("URL Error", for: URLError.self) { error in
            Text("Ok")
        }
    } else {
        Text("Not Supported")
    }
}
