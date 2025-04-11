import SwiftUI

struct AvatarIconView: View {
    var avatarImage: AvatarImage?
    var size: CGFloat = 50;
    
    var body: some View {
        Group {
            if let image = avatarImage {
                image.image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Circle().fill(Color.gray)
            }
        }
        .frame(width: size, height: size)
    }
}
