import SwiftUI
import SwiftUIError

struct FooError: Error {
    let date: Date
    let line: Int
    
    init(date: Date = Date(), line: Int = #line) {
        self.date = date
        self.line = line
    }
}

enum BarError: Error {
    case fatal(_ line: Int)
    case error(_ line: Int)
    
    static func makeFatal(_ line: Int = #line) -> Self {
        .fatal(line)
    }
    
    static func makeError(_ line: Int = #line) -> Self {
        .error(line)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct ExampleView: View {
    var body: some View {
        VStack {
            VStack {
                // This is caught in the "Foo Error" Alert
                ThrowingButton("FooError", action: { throw FooError() })
                
                // This is caught in the inner "Bar Error" Alert
                ThrowingButton("BarError.error", action: { throw BarError.makeError() })
            }
            .alert("Bar Error", for: BarError.self, message: { error in
                switch error {
                    case .error(let line):
                        Text("Error at line \(line)")
                    
                    case .fatal(let line):
                        Text("Fatal at line \(line)")
                }
            })
            .alert("Inner Foo Error", for: FooError.self, message: { error in
                VStack {
                    Text("thrown at line \(error.line)")
                    Text("thrown at \(error.date, format: .dateTime.hour().minute().second())")
                }
            })
            
            // This is not caught because it does not have an ancestor catching BarError
            ThrowingButton("BarError.fatal", action: { throw BarError.makeFatal() })
            
            // This is caught by the outter "Foo Error" onCatch
            ThrowingButton("FooError", action: { throw FooError() })
        }
        .onCatch(of: FooError.self, perform: { error in
            print("caught FooError in closure: ", error)
        })
        .onCatch { error in
            print("Any Error", error)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    ExampleView()
}
