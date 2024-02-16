//
//  SwiftUIView.swift
//  
//
//  Created by Noah Kamara on 16.02.24.
//

import SwiftUI

extension Binding {
    func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        self._isPresent
    }
}

extension Optional {
    fileprivate var _isPresent: Bool {
        get { self != nil }
        set {
            guard !newValue else { return }
            self = nil
        }
    }
    
    fileprivate subscript(default defaultSubscript: DefaultSubscript<Wrapped>) -> Wrapped {
        get {
            defaultSubscript.value = self ?? defaultSubscript.value
            return defaultSubscript.value
        }
        set {
            defaultSubscript.value = newValue
            if self != nil { self = newValue }
        }
    }
}

private final class DefaultSubscript<Value>: Hashable {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
    static func == (lhs: DefaultSubscript, rhs: DefaultSubscript) -> Bool {
        lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

