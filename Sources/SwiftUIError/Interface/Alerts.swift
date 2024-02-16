//
//  File.swift
//
//
//  Created by Noah Kamara on 16.02.24.
//

import SwiftUI

fileprivate struct ErrorAlertModifier<E: Error, A: View>: ViewModifier {
    @State
    var error: E? = nil
    
    let title: Text
    let actions: (E) -> A
    
    init(
        title: Text,
        actions: @escaping (E) -> A
    ) {
        self.title = title
        self.actions = actions
    }
    
    func body(content: Content) -> some View {
        content
            .onCatch(of: E.self, perform: { error in
                self.error = error
            })
        
    }
}


public extension View {
    func alert<E: Error, A: View>(
        title: Text,
        for type: E.Type = E.self,
        @ViewBuilder
        actions: @escaping (E) -> A
    ) -> some View {
        self.modifier(
            ErrorAlertModifier(
                title: title,
                actions: actions
            )
        )
    }
    
    func alert<E: Error, A: View, S: StringProtocol>(
        _ title: S,
        for type: E.Type = E.self,
        @ViewBuilder
        actions: @escaping (E) -> A
    ) -> some View {
        self.alert(title: Text(title), actions: actions)
    }
    
    func alert<E: Error, A: View>(
        _ titleKey: LocalizedStringKey,
        for type: E.Type = E.self,
        @ViewBuilder
        actions: @escaping (E) -> A
    ) -> some View {
        self.alert(title: Text(titleKey), actions: actions)
    }
}

