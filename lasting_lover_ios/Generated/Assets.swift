// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let button = ColorAsset(name: "Button")
    internal static let backgroundGradientBottom = ColorAsset(name: "background_gradient_bottom")
    internal static let backgroundGradientTop = ColorAsset(name: "background_gradient_top")
    internal static let graySolid = ColorAsset(name: "gray_solid")
    internal static let grayTransparent = ColorAsset(name: "gray_transparent")
    internal static let redError = ColorAsset(name: "red_error")
    internal static let redPaleError = ColorAsset(name: "red_pale_error")
    internal static let secondaryBtn = ColorAsset(name: "secondary_btn")
    internal static let tabBarBackground = ColorAsset(name: "tabBarBackground")
    internal static let tabColor0 = ColorAsset(name: "tabColor0")
    internal static let tabColor1 = ColorAsset(name: "tabColor1")
    internal static let text = ColorAsset(name: "text")
    internal static let white = ColorAsset(name: "white")
  }
  internal enum Images {
    internal static let setting = ImageAsset(name: "Setting")
    internal static let appleIcon = ImageAsset(name: "apple_icon")
    internal static let background = ImageAsset(name: "background")
    internal static let backgroundFlareImage = ImageAsset(name: "backgroundFlareImage")
    internal static let bookmark = ImageAsset(name: "bookmark")
    internal static let cherries = ImageAsset(name: "cherries")
    internal static let chevronLeft = ImageAsset(name: "chevron-left")
    internal static let chevronRight = ImageAsset(name: "chevron-right")
    internal static let close = ImageAsset(name: "close")
    internal static let edit = ImageAsset(name: "edit")
    internal static let facebookIcon = ImageAsset(name: "facebook_icon")
    internal static let fiMoreVertical = ImageAsset(name: "fi_more-vertical")
    internal static let fiTrash = ImageAsset(name: "fi_trash")
    internal static let googleIcon = ImageAsset(name: "google_icon")
    internal static let headphoneFill = ImageAsset(name: "headphone-fill")
    internal static let heart = ImageAsset(name: "heart")
    internal static let heartFilled = ImageAsset(name: "heart_filled")
    internal static let heartsIllustrtion = ImageAsset(name: "heartsIllustrtion")
    internal static let lips = ImageAsset(name: "lips")
    internal static let moon = ImageAsset(name: "moon")
    internal static let placeholder = ImageAsset(name: "placeholder")
    internal static let playInWhiteCircle = ImageAsset(name: "playInWhiteCircle")
    internal static let playerPauseButton = ImageAsset(name: "playerPauseButton")
    internal static let playerPlayButton = ImageAsset(name: "playerPlayButton")
    internal static let playerProgressBarIndicatorImage = ImageAsset(name: "playerProgressBarIndicatorImage")
    internal static let search = ImageAsset(name: "search")
    internal static let signInTitleimage = ImageAsset(name: "signInTitleimage")
    internal static let upload = ImageAsset(name: "upload")
    internal static let user = ImageAsset(name: "user")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
