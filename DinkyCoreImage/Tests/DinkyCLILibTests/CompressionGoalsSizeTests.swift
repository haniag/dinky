import DinkyCoreImage
import XCTest

/// Pure size math for percentage scaling and the max width cap (no encoders needed).
final class CompressionGoalsSizeTests: XCTestCase {
    func testNoGoalsLeavesSizeAlone() {
        XCTAssertNil(CompressionGoals().outputPixelSize(width: 800, height: 600))
    }

    func testUniformScale() throws {
        let size = try XCTUnwrap(CompressionGoals(scale: ImageScalePercent(uniform: 50)).outputPixelSize(width: 800, height: 600))
        XCTAssertEqual(size.width, 400)
        XCTAssertEqual(size.height, 300)
    }

    func testIndependentAxes() throws {
        let size = try XCTUnwrap(CompressionGoals(scale: ImageScalePercent(width: 100, height: 50)).outputPixelSize(width: 800, height: 600))
        XCTAssertEqual(size.width, 800)
        XCTAssertEqual(size.height, 300)
    }

    func testTinyScaleNeverReachesZero() throws {
        let size = try XCTUnwrap(CompressionGoals(scale: ImageScalePercent(uniform: 1)).outputPixelSize(width: 20, height: 10))
        XCTAssertEqual(size.width, 1)
        XCTAssertEqual(size.height, 1)
    }

    func testMaxWidthAppliesAfterScale() throws {
        let goals = CompressionGoals(maxWidth: 500, scale: ImageScalePercent(width: 50, height: 50))
        let size = try XCTUnwrap(goals.outputPixelSize(width: 2000, height: 1000))
        XCTAssertEqual(size.width, 500)
        XCTAssertEqual(size.height, 250)
    }

    func testScaleUnderMaxWidthIsKept() throws {
        let goals = CompressionGoals(maxWidth: 1920, scale: ImageScalePercent(uniform: 25))
        let size = try XCTUnwrap(goals.outputPixelSize(width: 4000, height: 3000))
        XCTAssertEqual(size.width, 1000)
        XCTAssertEqual(size.height, 750)
    }

    func testPercentagesAreClamped() {
        XCTAssertEqual(ImageScalePercent(width: 0, height: 9000), ImageScalePercent(width: 1, height: 400))
    }

    func testIdentityScaleDoesNotChangeDimensions() {
        XCTAssertFalse(CompressionGoals(scale: ImageScalePercent(uniform: 100)).changesDimensions)
        XCTAssertTrue(CompressionGoals(scale: ImageScalePercent(uniform: 99)).changesDimensions)
    }
}
