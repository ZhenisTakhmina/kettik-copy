
#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// MARK: - Asset Catalogs

public enum KTImages {
  public enum Brand {
    public static let logoNavBar = ImageAsset(name: "Brand/logo_nav_bar")
    public static let splashLogo = ImageAsset(name: "Brand/splash_logo")
  }
  public enum Control {
    public static let arrowRightSmall = ImageAsset(name: "Control/arrow_right_small")
    public static let backNavBar = ImageAsset(name: "Control/back_nav_bar")
    public static let decrement = ImageAsset(name: "Control/decrement")
    public static let increment = ImageAsset(name: "Control/increment")
    public static let likeNavBar = ImageAsset(name: "Control/like_nav_bar")
    public static let likedNavBar = ImageAsset(name: "Control/liked_nav_bar")
    public static let plus = ImageAsset(name: "Control/plus")
    public static let profileNavBar = ImageAsset(name: "Control/profile_nav_bar")
  }
  public enum Element {
    public static let blackGradient = ImageAsset(name: "Element/black_gradient")
    public static let verifiedQR = ImageAsset(name: "Element/qr1")
    public static let pendingQR = ImageAsset(name: "Element/qr2")
    public static let invalidQR = ImageAsset(name: "Element/qr3")
    public static let fullTicket = ImageAsset(name: "Element/full_ticket")
    public static let ticket = ImageAsset(name: "Element/ticket")
    public static let tripDetailsHeader = ImageAsset(name: "Element/trip_details_header")
  }
  public enum Icon {
    public static let calendar = ImageAsset(name: "Icon/calendar")
    public static let clock = ImageAsset(name: "Icon/clock")
    public static let heart = ImageAsset(name: "Icon/heart")
    public static let location = ImageAsset(name: "Icon/location")
    public static let locationSmall = ImageAsset(name: "Icon/location_small")
    public static let search = ImageAsset(name: "Icon/search")
  }
  public enum Illustration {
    public static let checkmark = ImageAsset(name: "Illustration/checkmark")
    public static let email = ImageAsset(name: "Illustration/email")
    public static let xCircle = ImageAsset(name: "Illustration/x_circle")
  }
  public enum Mock {
    public static let qr = ImageAsset(name: "Mock/qr")
  }
  public enum Profile {
    public static let faq = ImageAsset(name: "Profile/faq")
    public static let favorites = ImageAsset(name: "Profile/heart")
    public static let instagram = ImageAsset(name: "Profile/instagram")
    public static let google = ImageAsset(name: "Profile/google")
    public static let language = ImageAsset(name: "Profile/language")
    public static let myProfile = ImageAsset(name: "Profile/my_profile")
    public static let myTickets = ImageAsset(name: "Profile/my_tickets")
    public static let signOut = ImageAsset(name: "Profile/sign_out")
    public static let telegram = ImageAsset(name: "Profile/telegram")
    public static let whatsApp = ImageAsset(name: "Profile/whats_app")
  }
  public enum Tab {
    public static let orders = ImageAsset(name: "Tab/orders")
    public static let explore = ImageAsset(name: "Tab/explore")
    public static let guides = ImageAsset(name: "Tab/guides")
    public static let profile = ImageAsset(name: "Tab/profile")
    public static let tabShadow = ImageAsset(name: "Tab/tab_shadow")
  }
  public static let image = ImageAsset(name: "image")
}

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
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

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
