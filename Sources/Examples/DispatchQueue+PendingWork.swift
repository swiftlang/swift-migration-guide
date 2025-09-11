import Dispatch

extension DispatchQueue {
    /// Returns once any pending work has been completed.
    func pendingWorkComplete() async {
        await withCheckedContinuation { continuation in
            self.async(flags: .barrier) {
                continuation.resume()
            }
        }
    }
}
