//
//  SwiftUIView.swift
//  
//
//  Created by Noah Kamara on 17.02.24.
//

import SwiftUI

struct ErrorSheetModifier<E: Error, Sheet: View>: ViewModifier {
    @State
    var error: E? = nil
    
    let onDismiss: (() -> Void)?
    let sheetContent: (Binding<E>) -> Sheet
    
    init(onDismiss: (() -> Void)?, sheet: @escaping (Binding<E>) -> Sheet) {
        self.onDismiss = onDismiss
        self.sheetContent = sheet
    }
    
    func body(content: Content) -> some View {
        content
            .onCatch(of: E.self, perform: { error in
                self.error = error
            })
            .sheet(isPresented: $error.isPresent()) {
                Binding($error).map(sheetContent)
            }
            
    }
}

extension View {
    func sheet<E: Error, Content: View>(
        for error: E.Type,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (Binding<E>) -> Content
    ) -> some View {
        self.modifier(ErrorSheetModifier<E,Content>(onDismiss: onDismiss, sheet: content))
    }
}


#Preview {
    ThrowingButton("Press Me", action: {
        throw URLError(.cancelled)
    })
    .sheet(for: URLError.self) { $error in
        Text(error.localizedDescription)
    }
}
