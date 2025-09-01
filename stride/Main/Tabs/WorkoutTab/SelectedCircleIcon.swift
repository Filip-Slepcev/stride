import SwiftUI

struct SelectedCircle: View {
    var isSelected: Bool
    var body: some View {
        ZStack {
            if isSelected {
                Circle().strokeBorder(.orange, lineWidth: 2).frame(width: 25, height: 25).padding(.trailing, 40)
                Circle().fill(.orange).scaleEffect(0.65).frame(width: 25, height: 25).padding(.trailing, 40)
            } else {
                Circle().strokeBorder(.gray).frame(width: 25, height: 25).padding(.trailing, 40)
            }
        }
    }
}
