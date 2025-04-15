import AuthenticationServices
import Supabase
import SwiftUI

struct AppleAuthView: View {
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            Task {
                do {
                    guard
                        let credential = try result.get().credential
                            as? ASAuthorizationAppleIDCredential
                    else {
                        print("ERROR ASAUTHORIZATIONAPPLEIDCREDENTIAL")
                        return
                    }

                    guard
                        let idToken = credential.identityToken
                            .flatMap({ String(data: $0, encoding: .utf8) })
                    else {
                        print("ERROR IDTOKEN")
                        return
                    }
                    try await supabase.auth.signInWithIdToken(
                        credentials: .init(
                            provider: .apple,
                            idToken: idToken
                        )
                    )
                } catch {
                    dump(error)
                }
            }
        }.frame(width: 300, height: 50)
    }
}
