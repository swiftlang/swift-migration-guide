import XCTest

final class DispatchQueuePendingWorkTests: XCTestCase {
    func testPendingWorkCompleteRunsAfterAsyncBlock() async {
        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)
        let expectation = XCTestExpectation(description: "Work finished")
        var value = 0

        // Enqueue some async work on the queue
        queue.async {
            value = 42
            expectation.fulfill()
        }

        // Wait until the queue says all prior work has completed
        await queue.pendingWorkComplete()

        // At this point, value should be updated
        XCTAssertEqual(value, 42)

        // Make sure the async block really executed
        wait(for: [expectation], timeout: 1.0)
    }
}
