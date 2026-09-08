import SwiftUI

// Color palette approximating the web app's Tailwind amber/stone/red tokens.
enum Theme {
    static let amber50 = Color(red: 1.00, green: 0.984, blue: 0.922)   // #fffbeb
    static let amber100 = Color(red: 0.996, green: 0.953, blue: 0.780) // #fef3c7
    static let amber900 = Color(red: 0.471, green: 0.208, blue: 0.059) // #78350f
    static let stone50 = Color(red: 0.980, green: 0.980, blue: 0.976)  // #fafaf9
    static let stone100 = Color(red: 0.961, green: 0.961, blue: 0.957) // #f5f5f4
    static let stone400 = Color(red: 0.659, green: 0.635, blue: 0.620) // #a8a29e
    static let stone500 = Color(red: 0.471, green: 0.443, blue: 0.424) // #78716c
    static let stone600 = Color(red: 0.341, green: 0.325, blue: 0.310) // #57534e
    static let stone700 = Color(red: 0.267, green: 0.251, blue: 0.235) // #44403c
    static let stone800 = Color(red: 0.161, green: 0.145, blue: 0.141) // #292524
    static let red900 = Color(red: 0.498, green: 0.114, blue: 0.114)   // #7f1d1d

    static let parchment = LinearGradient(
        colors: [Color(red: 0.980, green: 0.961, blue: 0.910), Color(red: 0.961, green: 0.937, blue: 0.878)],
        startPoint: .top, endPoint: .bottom
    )

    // Stand-ins for the web app's Cormorant Garamond ("display") and
    // EB Garamond ("serif") web fonts, which aren't bundled natively yet.
    // TODO: bundle the actual Cormorant/EB Garamond .ttf files and register
    // them via Info.plist's UIAppFonts to match the web app exactly.
    static func display(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}
