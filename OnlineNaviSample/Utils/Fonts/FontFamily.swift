import Foundation

public protocol FontFamily {
    var bold: String { get }
    var boldItalic: String { get }
    var extraBold: String { get }
    var extraBoldItalic: String { get }
    var italic: String { get }
    var light: String { get }
    var lightItalic: String { get }
    var regular: String { get }
    var semiBold: String { get }
    var semiBoldItalic: String { get }
    var iconFont: String { get }
}

// MARK: - Default values
public extension FontFamily {
    var bold: String { return "HelveticaNeue-Bold" }
    var boldItalic: String { return "HelveticaNeue-BoldItalic" }
    var extraBold: String { return "HelveticaNeue-Bold" }
    var extraBoldItalic: String { return "HelveticaNeue-BoldItalic" }
    var italic: String { return "HelveticaNeue-Italic" }
    var light: String { fatalError("Not implemented font") }
    var lightItalic: String { fatalError("Not implemented font") }
    var regular: String { return "HelveticaNeue" }
    var semiBold: String { return "HelveticaNeue-Medium" }
    var semiBoldItalic: String { return "HelveticaNeue-MediumItalic" }
    var iconFont: String { return "SygicIcons" }
}

public struct DefaultFontFamily: FontFamily {
    public init() {}
}
