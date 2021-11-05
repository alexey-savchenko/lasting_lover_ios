// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Next
  internal static let buttonNext = L10n.tr("Localizable", "button_next")
  /// Lorem ipsum dolor sit amet, consectetur adipiscing elit elit more.
  internal static let congratulationsSubtitle = L10n.tr("Localizable", "congratulations_subtitle")
  /// Congratulations!
  internal static let congratulationsTitle = L10n.tr("Localizable", "congratulations_title")
  /// Authors
  internal static let discoverAuthors = L10n.tr("Localizable", "discover_authors")
  /// Discover new impressions
  internal static let discoverTitle = L10n.tr("Localizable", "discover_title")
  /// Network unreachable
  internal static let errorNetworkUnreachable = L10n.tr("Localizable", "error_network_unreachable")
  /// Discover
  internal static let mainTabDiscover = L10n.tr("Localizable", "main_tab_discover")
  /// Sleep
  internal static let mainTabSleep = L10n.tr("Localizable", "main_tab_sleep")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Email Adress
  internal static let signInEmailTextfieldPlaceholder = L10n.tr("Localizable", "signIn_emailTextfield_placeholder")
  /// or sign up with social media
  internal static let signInHintLabelText = L10n.tr("Localizable", "signIn_hintLabel_text")
  /// Password
  internal static let signInPassTextfieldPlaceholder = L10n.tr("Localizable", "signIn_passTextfield_placeholder")
  /// Sign In
  internal static let signInSubmitButtonText = L10n.tr("Localizable", "signIn_submitButton_text")
  /// Lorem ipsum dolor sit amet, consectetur adipiscing elit elit more.
  internal static let signInSubtitleLabelText = L10n.tr("Localizable", "signIn_subtitleLabel_text")
  /// Don’t  have an account?
  internal static let signInSwitchModeButtonTitlePart1 = L10n.tr("Localizable", "signIn_switchModeButton_title_part1")
  /// Sign up
  internal static let signInSwitchModeButtonTitlePart2 = L10n.tr("Localizable", "signIn_switchModeButton_title_part2")
  /// Welcome Back!
  internal static let signInTitleLabelText = L10n.tr("Localizable", "signIn_titleLabel_text")
  /// I have an account
  internal static let signInTitleScreenSignInButtonTitle = L10n.tr("Localizable", "signInTitleScreen_signInButton_title")
  /// Sign Up
  internal static let signInTitleScreenSignUpButtonTitle = L10n.tr("Localizable", "signInTitleScreen_signUpButton_title")
  /// Lorem ipsum dolor sit amet, consectetur adipiscing elit elit more.
  internal static let signInTitleScreenSubtitle = L10n.tr("Localizable", "signInTitleScreen_subtitle")
  /// Lasting lover
  internal static let signInTitleScreenTitle = L10n.tr("Localizable", "signInTitleScreen_title")
  /// Sign Up
  internal static let signUpSubmitButtonText = L10n.tr("Localizable", "signUp_submitButton_text")
  /// Lorem ipsum dolor sit amet, consectetur adipiscing elit elit more.
  internal static let signUpSubtitleLabelText = L10n.tr("Localizable", "signUp_subtitleLabel_text")
  /// Do you have an account?
  internal static let signUpSwitchModeButtonTitlePart1 = L10n.tr("Localizable", "signUp_switchModeButton_title_part1")
  /// Sign in
  internal static let signUpSwitchModeButtonTitlePart2 = L10n.tr("Localizable", "signUp_switchModeButton_title_part2")
  /// Welcome!
  internal static let signUpTitleLabelText = L10n.tr("Localizable", "signUp_titleLabel_text")
  /// Today popular?
  internal static let todaysPopular = L10n.tr("Localizable", "Todays_popular")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
