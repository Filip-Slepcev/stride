import SwiftUI

struct SheetRectangle: View {
    var body: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 25).fill(
                .black.opacity(0.1)
            ).frame(
                width: UIScreen.width / 8,
                height: 5
            ).padding(.top, -30)
            Spacer()
        }
    }
}
