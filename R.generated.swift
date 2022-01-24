//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Onboarding`.
    static let onboarding = _R.storyboard.onboarding()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Onboarding", bundle: ...)`
    static func onboarding(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.onboarding)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 16 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `black`.
    static let black = Rswift.ColorResource(bundle: R.hostingBundle, name: "black")
    /// Color `error`.
    static let error = Rswift.ColorResource(bundle: R.hostingBundle, name: "error")
    /// Color `focus`.
    static let focus = Rswift.ColorResource(bundle: R.hostingBundle, name: "focus")
    /// Color `gray1`.
    static let gray1 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray1")
    /// Color `gray2`.
    static let gray2 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray2")
    /// Color `gray3`.
    static let gray3 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray3")
    /// Color `gray4`.
    static let gray4 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray4")
    /// Color `gray5`.
    static let gray5 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray5")
    /// Color `gray6`.
    static let gray6 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray6")
    /// Color `gray7`.
    static let gray7 = Rswift.ColorResource(bundle: R.hostingBundle, name: "gray7")
    /// Color `green`.
    static let green = Rswift.ColorResource(bundle: R.hostingBundle, name: "green")
    /// Color `success`.
    static let success = Rswift.ColorResource(bundle: R.hostingBundle, name: "success")
    /// Color `white`.
    static let white = Rswift.ColorResource(bundle: R.hostingBundle, name: "white")
    /// Color `whitegreen`.
    static let whitegreen = Rswift.ColorResource(bundle: R.hostingBundle, name: "whitegreen")
    /// Color `yellowgreen`.
    static let yellowgreen = Rswift.ColorResource(bundle: R.hostingBundle, name: "yellowgreen")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "black", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.black, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "error", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func error(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.error, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "focus", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func focus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.focus, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray1", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray2", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray3", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray3, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray4", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray4, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray5", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray5(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray5, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray6", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray6(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray6, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "gray7", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray7(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray7, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "green", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func green(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.green, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "success", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func success(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.success, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "white", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "whitegreen", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func whitegreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.whitegreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "yellowgreen", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func yellowgreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.yellowgreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "black", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func black(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.black.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "error", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func error(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.error.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "focus", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func focus(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.focus.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray1", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray1(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray1.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray2", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray2(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray2.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray3", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray3(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray3.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray4", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray4(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray4.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray5", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray5(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray5.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray6", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray6(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray6.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "gray7", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray7(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray7.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "green", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func green(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.green.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "success", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func success(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.success.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "white", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func white(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.white.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "whitegreen", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func whitegreen(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.whitegreen.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "yellowgreen", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func yellowgreen(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.yellowgreen.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.entitlements` struct is generated, and contains static references to 1 properties.
  struct entitlements {
    static let apsEnvironment = infoPlistString(path: [], key: "aps-environment") ?? "development"

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")

    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 5 images.
  struct image {
    /// Image `Onboarding1`.
    static let onboarding1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "Onboarding1")
    /// Image `Onboarding2`.
    static let onboarding2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "Onboarding2")
    /// Image `Onboarding3`.
    static let onboarding3 = Rswift.ImageResource(bundle: R.hostingBundle, name: "Onboarding3")
    /// Image `man`.
    static let man = Rswift.ImageResource(bundle: R.hostingBundle, name: "man")
    /// Image `woman`.
    static let woman = Rswift.ImageResource(bundle: R.hostingBundle, name: "woman")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "Onboarding1", bundle: ..., traitCollection: ...)`
    static func onboarding1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.onboarding1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "Onboarding2", bundle: ..., traitCollection: ...)`
    static func onboarding2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.onboarding2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "Onboarding3", bundle: ..., traitCollection: ...)`
    static func onboarding3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.onboarding3, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "man", bundle: ..., traitCollection: ...)`
    static func man(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.man, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "woman", bundle: ..., traitCollection: ...)`
    static func woman(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.woman, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"
            static let uiSceneStoryboardFile = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneStoryboardFile") ?? "Main"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `OnboardingCollectionViewCell`.
    static let onboardingCollectionViewCell: Rswift.ReuseIdentifier<OnboardingCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "OnboardingCollectionViewCell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try onboarding.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = OnboardingViewController

      let bundle = R.hostingBundle
      let name = "Main"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct onboarding: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = OnboardingViewController

      let bundle = R.hostingBundle
      let name = "Onboarding"
      let onboardingViewController = StoryboardViewControllerResource<OnboardingViewController>(identifier: "OnboardingViewController")

      func onboardingViewController(_: Void = ()) -> OnboardingViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: onboardingViewController)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "black", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'black' is used in storyboard 'Onboarding', but couldn't be loaded.") }
          if UIKit.UIColor(named: "gray5", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'gray5' is used in storyboard 'Onboarding', but couldn't be loaded.") }
          if UIKit.UIColor(named: "green", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'green' is used in storyboard 'Onboarding', but couldn't be loaded.") }
          if UIKit.UIColor(named: "white", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'white' is used in storyboard 'Onboarding', but couldn't be loaded.") }
        }
        if _R.storyboard.onboarding().onboardingViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'onboardingViewController' could not be loaded from storyboard 'Onboarding' as 'OnboardingViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
