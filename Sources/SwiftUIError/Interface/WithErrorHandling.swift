import SwiftUI

public struct WithErrorHandling<Content: View>: View {
    @Environment(\.errorHandling)
    private var errorHandling
    
    let content: (ErrorHandling) -> Content
    
    public init(@ViewBuilder content: @escaping (ErrorHandling) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(errorHandling)
    }
}

#Preview {
    WithErrorHandling { errors in
        ThrowingButton("Press Me") {
            throw URLError(.cancelled)
        }
    }
}
