import SwiftUI

fileprivate struct ErrorSheetModifier<E: Error, Sheet: View>: ViewModifier {
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

public extension View {
    /// Presents a sheet when an errro of the provided type is thrown
    ///
    /// Use this method when you need to present a modal view with content
    /// from a an error. The example below shows an a sheet capturing
    /// `URLError` that the `content` closure uses to populate the display
    /// the action sheet shows to the user:
    /// ```swift
    /// struct ShowLicenseAgreement: View {
    ///     var body: some View {
    ///         ThrowingButton("Throw Error", action: {
    ///             throw URLError(.cancelled)
    ///         })
    ///         .sheet(for: URLError.self, onDismiss: didDismiss) { $error in
    ///             Text(error.localizedDescription)
    ///         }
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    /// ```
    ///
    /// In vertically compact environments, such as iPhone in landscape
    /// orientation, a sheet presentation automatically adapts to appear as a
    /// full-screen cover. Use the ``View/presentationCompactAdaptation(_:)`` or
    /// ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifier to
    /// override this behavior.
    ///
    /// - Parameters:
    ///   - error: The Type of error that triggers this sheet
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
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
