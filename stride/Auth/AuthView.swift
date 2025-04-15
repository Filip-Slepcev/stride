import Supabase
import SwiftUI

struct AuthView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("StrideIcon").resizable().frame(width: 125, height: 125)
            VStack(alignment: .center) {
                Text("Stride").font(.system(size: 40)).bold()
                Text("Your goto place to track your workouts").font(.system(size: 20))
                    .foregroundStyle(.gray).padding(.top, 10)
            }.padding(.top, -20)
                .padding(.bottom, 100)
                
            AppleAuthView()
            Spacer()
        }

    }
}

#Preview {
    AuthView()
}
