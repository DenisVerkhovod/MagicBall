// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Answer {
    /// Great idea!
    internal static let preset1 = L10n.tr("Localizable", "answer.preset1")
    /// Let's do it!
    internal static let preset2 = L10n.tr("Localizable", "answer.preset2")
    /// Not now
    internal static let preset3 = L10n.tr("Localizable", "answer.preset3")
    /// Maybe next time
    internal static let preset4 = L10n.tr("Localizable", "answer.preset4")
  }

  internal enum Main {
    /// Try me!
    internal static let answerLabelDefaultText = L10n.tr("Localizable", "main.answerLabelDefaultText")
    /// Try again later!
    internal static let defaultAnswer = L10n.tr("Localizable", "main.defaultAnswer")
    /// Ask the Ball and shake!
    internal static let title = L10n.tr("Localizable", "main.title")
    /// Total shakes: 
    internal static let totalShakes = L10n.tr("Localizable", "main.totalShakes")
  }

  internal enum Settings {
    /// Add
    internal static let addButtonTitle = L10n.tr("Localizable", "settings.addButtonTitle")
    /// Delete
    internal static let deleteActionTitle = L10n.tr("Localizable", "settings.deleteActionTitle")
    /// Type answer to add...
    internal static let textFieldPlaceholderText = L10n.tr("Localizable", "settings.textFieldPlaceholderText")
    /// Help Magic Ball by adding your answers!
    internal static let title = L10n.tr("Localizable", "settings.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
