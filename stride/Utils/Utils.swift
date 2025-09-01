import Foundation
import SwiftUI

extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

public extension View {
    func addBorder<S>(_ content: S, thickness: CGFloat = 1, cornerRadius: CGFloat, padding: EdgeInsets = EdgeInsets()) -> some View where S: ShapeStyle {
        self.padding(padding).background(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: thickness))
    }
}

extension EdgeInsets {
    static func all(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }

    static func horizontal(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: value)
    }

    static func vertical(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: value, trailing: 0)
    }
}

public var OrangeTheme = Color(red: 252 / 255, green: 100 / 255, blue: 57 / 255)
