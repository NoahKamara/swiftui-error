import SwiftUI
import SwiftUIError


struct MakeProblemButton<E: Error>: View {
    let error: E
    @Environment(\.errorHandling)
    var errors
    
    init(throws error: E) {
        self.error = error
    }
    
    var body: some View {
        ThrowingButton("Throw \(error.localizedDescription)", action: {
            throw error
        })
    }
}
