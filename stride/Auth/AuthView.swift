import Supabase
import SwiftUI

struct AuthView: View {
    @State var email = ""
    @State var isLoading = false
    @State var result: Result<Void, Error>?

    var body: some View {
        VStack {
            Spacer()
            Image("StrideIcon").resizable().frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text("Login").font(.system(size: 40)).bold()
                Text("Please sign in to continue").font(.system(size: 20))
                    .foregroundStyle(.gray)
            }.padding(.leading, -90)
            VStack {
                Section {
                    HStack {
                        Image(systemName: "envelope")
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.vertical, 20)
                    }
                    .padding(.leading, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                ).padding(.top, 20)
                .padding(.horizontal, 40)
                .padding(.vertical, 50)

                Button(action: {
                    signInButtonTapped()
                }) {
                    HStack {
                        Text("Login")
                        Image(systemName: "arrow.right").resizable().frame(
                            width: 20,
                            height: 15
                        )
                    }
                }.padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    ).foregroundStyle(.orange)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Spacer()
                    if isLoading {
                        ProgressView()
                    }
                    if let result {
                        Section {
                            switch result {
                            case .success:
                                Text("Login sent to your email").foregroundStyle(
                                    .gray
                                ).bold()
                            case .failure(let error):
                                Text(error.localizedDescription)
                                    .foregroundStyle(
                                        .red
                                    )
                                    .bold()
                            }
                        }
                    }
                    Spacer()
                }.padding(.top, 50)
            }
            .onOpenURL(perform: { url in
                Task {
                    do {
                        try await supabase.auth.session(from: url)
                        
                    } catch {
                        self.result = .failure(error)
                    }
                }
            }).scrollContentBackground(.hidden)  // 👈 This is key in iOS 16+
            .background(Color.clear)
            Spacer()
        }.padding(.top, -50)
        
    }

    func signInButtonTapped() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await supabase.auth.signInWithOTP(
                    email: email,
                    redirectTo: URL(string: "strive://login-callback")
                )
                result = .success(())
            } catch {
                result = .failure(error)
            }
        }
    }
}

#Preview {
    AuthView()
}
