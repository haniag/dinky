import DinkyCoreShared
import Foundation

/// Scales an image's width and height independently, as a percentage of the original pixel size.
public struct ImageScalePercent: Sendable, Equatable {
    /// Allowed percentages: shrink to 1% or enlarge up to 4×.
    public static let allowedRange: ClosedRange<Int> = 1...400

    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = Self.clamped(width)
        self.height = Self.clamped(height)
    }

    /// Same percentage on both axes (keeps the aspect ratio).
    public init(uniform percent: Int) {
        self.init(width: percent, height: percent)
    }

    public static func clamped(_ percent: Int) -> Int {
        min(allowedRange.upperBound, max(allowedRange.lowerBound, percent))
    }

    public var isIdentity: Bool { width == 100 && height == 100 }
}

public struct CompressionGoals: Sendable {
    public var maxWidth: Int?
    public var maxFileSizeKB: Int?
    /// Percentage resize, applied before ``maxWidth`` (which still caps the scaled result).
    public var scale: ImageScalePercent?

    public init(maxWidth: Int? = nil, maxFileSizeKB: Int? = nil, scale: ImageScalePercent? = nil) {
        self.maxWidth = maxWidth
        self.maxFileSizeKB = maxFileSizeKB
        self.scale = scale
    }

    /// True when these goals may change pixel dimensions.
    public var changesDimensions: Bool {
        maxWidth != nil || (scale.map { !$0.isIdentity } ?? false)
    }

    /// Output pixel size for an image of `width`×`height` (display orientation), or nil when unchanged.
    /// Percentage scaling runs first; the max width then caps the result, keeping its proportions.
    public func outputPixelSize(width: Int, height: Int) -> (width: Int, height: Int)? {
        guard width > 0, height > 0 else { return nil }
        var outW = width
        var outH = height
        if let scale {
            outW = max(1, Int((Double(width) * Double(scale.width) / 100).rounded()))
            outH = max(1, Int((Double(height) * Double(scale.height) / 100).rounded()))
        }
        if let maxWidth, maxWidth > 0, outW > maxWidth {
            outH = max(1, Int((Double(outH) * Double(maxWidth) / Double(outW)).rounded()))
            outW = maxWidth
        }
        guard outW != width || outH != height else { return nil }
        return (outW, outH)
    }
}
