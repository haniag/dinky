import DinkyCoreImage
import DinkyCoreShared
import Foundation

public struct DinkyCompressOptions: Sendable {
    public var format: String
    public var quality: Int?
    public var maxWidth: Int?
    public var maxFileSizeKB: Int?
    /// Percentage of the original width/height; nil leaves that axis to the other one (or unscaled).
    public var scaleWidthPercent: Int?
    public var scaleHeightPercent: Int?
    public var stripMetadata: Bool
    public var outputDir: URL?
    public var smartQuality: Bool
    public var contentTypeHint: String
    public var parallelLimit: Int
    public var collisionStyle: CollisionNamingStyle
    public var collisionCustomPattern: String
    public var json: Bool
    public var chromaSubsamplingRaw: String
    public var webpLossless: Bool
    public var pngOutputModeRaw: String

    public init(
        format: String = "auto",
        quality: Int? = nil,
        maxWidth: Int? = nil,
        maxFileSizeKB: Int? = nil,
        scaleWidthPercent: Int? = nil,
        scaleHeightPercent: Int? = nil,
        stripMetadata: Bool = true,
        outputDir: URL? = nil,
        smartQuality: Bool = true,
        contentTypeHint: String = "auto",
        parallelLimit: Int = 3,
        collisionStyle: CollisionNamingStyle = .finderDuplicate,
        collisionCustomPattern: String = "",
        json: Bool = false,
        chromaSubsamplingRaw: String = ChromaSubsampling.auto.rawValue,
        webpLossless: Bool = false,
        pngOutputModeRaw: String = PNGOutputMode.lossless.rawValue
    ) {
        self.format = format
        self.quality = quality
        self.maxWidth = maxWidth
        self.maxFileSizeKB = maxFileSizeKB
        self.scaleWidthPercent = scaleWidthPercent
        self.scaleHeightPercent = scaleHeightPercent
        self.stripMetadata = stripMetadata
        self.outputDir = outputDir
        self.smartQuality = smartQuality
        self.contentTypeHint = contentTypeHint
        self.parallelLimit = parallelLimit
        self.collisionStyle = collisionStyle
        self.collisionCustomPattern = collisionCustomPattern
        self.json = json
        self.chromaSubsamplingRaw = chromaSubsamplingRaw
        self.webpLossless = webpLossless
        self.pngOutputModeRaw = pngOutputModeRaw
    }

    /// Percentage resize from the scale flags. Giving only one axis scales both by it (keeps proportions).
    public var scale: ImageScalePercent? {
        switch (scaleWidthPercent, scaleHeightPercent) {
        case (nil, nil): return nil
        case let (w?, nil): return ImageScalePercent(uniform: w)
        case let (nil, h?): return ImageScalePercent(uniform: h)
        case let (w?, h?): return ImageScalePercent(width: w, height: h)
        }
    }
}
