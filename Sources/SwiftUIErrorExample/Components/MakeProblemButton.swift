//
//  SwiftUIView 2.swift
//  
//
//  Created by Noah Kamara on 16.02.24.
//

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
