import SwiftUI


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Adds an asynchronous throwing task to perform before this view appears.
    ///
    /// Use this modifier to perform an asynchronous task with a lifetime that
    /// matches that of the modified view. If the task doesn't finish
    /// before SwiftUI removes the view or the view changes identity, SwiftUI
    /// cancels the task.
    ///
    /// - Parameters:
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is
    ///     <doc://com.apple.documentation/documentation/Swift/TaskPriority/userInitiated>.
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     before the view appears. SwiftUI will automatically cancel the task
    ///     at some point after the view disappears before the action completes.
    ///
    ///
    /// - Returns: A view that runs the specified action asynchronously before
    ///   the view appears.
    @inlinable public func throwingTask(
        priority: TaskPriority = .userInitiated,
        _ action: @escaping @Sendable () async throws -> Void
    ) -> some View {
        WithErrorHandling { errors in
            self.task(priority: priority) {
                do {
                    try await action()
                } catch {
                    await errors.push(error)
                }
            }
        }
    }
    
    
    /// Adds a task to perform before this view appears or when a specified
    /// value changes.
    ///
    /// This method behaves like ``View/throwingTask(priority:_:)``, except that it also
    /// cancels and recreates the task when a specified value changes. To detect
    /// a change, the modifier tests whether a new value for the `id` parameter
    /// equals the previous value. For this to work,
    /// the value's type must conform to the
    /// <doc://com.apple.documentation/documentation/Swift/Equatable> protocol.
    ///
    ///
    /// - Parameters:
    ///   - id: The value to observe for changes. The value must conform
    ///     to the <doc://com.apple.documentation/documentation/Swift/Equatable>
    ///     protocol.
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is
    ///     <doc://com.apple.documentation/documentation/Swift/TaskPriority/userInitiated>.
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     before the view appears. SwiftUI can automatically cancel the task
    ///     after the view disappears before the action completes. If the
    ///     `id` value changes, SwiftUI cancels and restarts the task.
    ///
    /// - Returns: A view that runs the specified action asynchronously before
    ///   the view appears, or restarts the task when the `id` value changes.
    @inlinable public func throwingTask<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        _ action: @escaping @Sendable () async throws -> Void
    ) -> some View where T : Equatable {
        WithErrorHandling { errors in
            self.task<T>(id: value, priority: priority) {
                do {
                    try await action()
                } catch {
                    await errors.push(error)
                }
            }
        }
    }
}
