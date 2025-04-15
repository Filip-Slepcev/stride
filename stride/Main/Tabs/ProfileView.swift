import PhotosUI
import SwiftUI

struct ProfileDetailSection: View {
    @Binding var imageSelection: PhotosPickerItem?
    @Binding var username: String
    @Binding var bio: String
    @Binding var avatarImage: AvatarImage?

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $imageSelection,
                matching: .images
            ) {
                AvatarIconView(avatarImage: avatarImage, size: 75)
            }
            Text("Edit photo")
                .foregroundColor(.blue.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden)

        TextField("Username", text: $username)
            .textContentType(.username)
            .textInputAutocapitalization(.never)

        TextField("Bio", text: $bio)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
    }
}

struct ProfileView: View {
    @EnvironmentObject private var activeUser: ActiveUser
    @State private var username = ""
    @State private var bio = ""
    @State private var avatarImage: AvatarImage?

    @State private var imageSelection: PhotosPickerItem?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ProfileDetailSection(
                        imageSelection: $imageSelection,
                        username: $username,
                        bio: $bio,
                        avatarImage: $avatarImage
                    )
                }
                Section {
                    Button("Update profile") {
                        onUpdateProfile()
                    }
                    .bold()
                    if isLoading {
                        ProgressView()
                    }
                }
                Section {
                    Button("Sign out") {
                        signOut()
                    }
                    .bold()
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                username = activeUser.username ?? ""
                bio = activeUser.bio ?? ""
                avatarImage = activeUser.avatarImage
            }
            .onChange(of: imageSelection) { _, newValue in
                guard let newValue else { return }
                loadTransferable(from: newValue)
            }
        }
    }

    private func signOut() {
        Task {
            await activeUser.logout()
        }
    }

    private func onUpdateProfile() {
        Task {
            isLoading = true
            await activeUser.updateProfile(
                username: username,
                bio: bio
            )
            isLoading = false
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        Task {
            do {
                avatarImage = try await imageSelection.loadTransferable(
                    type: AvatarImage.self
                )
                try await activeUser.uploadImage(image: avatarImage)
            } catch {
                debugPrint("Failed to load image:", error)
            }
        }
    }
}
