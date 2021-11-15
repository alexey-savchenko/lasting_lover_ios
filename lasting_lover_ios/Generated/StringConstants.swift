// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// All Tracks
  internal static let allTracks = L10n.tr("Localizable", "All Tracks")
  /// Top
  internal static let authorTopStoriesTitle = L10n.tr("Localizable", "author_topStories_title")
  /// Next
  internal static let buttonNext = L10n.tr("Localizable", "button_next")
  /// Lorem ipsum dolor sit amet, consectetur adipiscing elit elit more.
  internal static let congratulationsSubtitle = L10n.tr("Localizable", "congratulations_subtitle")
  /// Congratulations!
  internal static let congratulationsTitle = L10n.tr("Localizable", "congratulations_title")
  /// All Series
  internal static let discoverAllSeries = L10n.tr("Localizable", "discover_All_Series")
  /// Authors
  internal static let discoverAuthors = L10n.tr("Localizable", "discover_authors")
  /// Categories
  internal static let discoverCategories = L10n.tr("Localizable", "discover_categories")
  /// Featured Series
  internal static let discoverFeaturedSeries = L10n.tr("Localizable", "discover_Featured_Series")
  /// New sexy stories
  internal static let discoverNewSexyStories = L10n.tr("Localizable", "discover_New_sexy_stories")
  /// New topic
  internal static let discoverNewTopic = L10n.tr("Localizable", "discover_new_topic")
  /// See all
  internal static let discoverSeeAll = L10n.tr("Localizable", "discover_see_all")
  /// Discover new impressions
  internal static let discoverTitle = L10n.tr("Localizable", "discover_title")
  /// Network unreachable
  internal static let errorNetworkUnreachable = L10n.tr("Localizable", "error_network_unreachable")
  /// Something went wrong..
  internal static let generalError = L10n.tr("Localizable", "general_error")
  /// OK
  internal static let generalOk = L10n.tr("Localizable", "general_ok")
  /// Discover
  internal static let mainTabDiscover = L10n.tr("Localizable", "main_tab_discover")
  /// Favorites
  internal static let mainTabFavorites = L10n.tr("Localizable", "main_tab_favorites")
  /// Sleep
  internal static let mainTabSleep = L10n.tr("Localizable", "main_tab_sleep")
  /// Series List
  internal static let seriesList = L10n.tr("Localizable", "series_list")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Manage Subscription
  internal static let settingsManageSubscription = L10n.tr("Localizable", "settings_Manage Subscription")
  /// Notifications
  internal static let settingsNotifications = L10n.tr("Localizable", "settings_Notifications")
  /// Privacy Policy
  internal static let settingsPrivacyPolicy = L10n.tr("Localizable", "settings_Privacy Policy")
  /// Terms and Conditions
  internal static let settingsTermsAndConditions = L10n.tr("Localizable", "settings_Terms and Conditions")
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
  /// Featured
  internal static let sleepFeatured = L10n.tr("Localizable", "sleep_Featured")
  /// Sleep
  internal static let sleepTitle = L10n.tr("Localizable", "sleep_title")
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
