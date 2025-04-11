import PhotosUI
import SwiftUI

struct ProfileDetailSection: View {
    @Binding var imageSelection: PhotosPickerItem?
    @Binding var username: String
    @Binding var fullName: String
    @Binding var website: String
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

        TextField("Full name", text: $fullName)
            .textContentType(.name)

        TextField("Website", text: $website)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
    }
}

struct ProfileView: View {
    @EnvironmentObject private var activeUser: ActiveUser
    @State private var username = ""
    @State private var fullName = ""
    @State private var website = ""
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
                        fullName: $fullName,
                        website: $website,
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
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem {
                    Button("Sign out", role: .destructive) {
                        Task {
                            await activeUser.logout()
                        }
                    }
                }
            }
            .onAppear {
                username = activeUser.username ?? ""
                fullName = activeUser.fullName ?? ""
                website = activeUser.website ?? ""
                avatarImage = activeUser.avatarImage
            }
            .onChange(of: imageSelection) { _, newValue in
                guard let newValue else { return }
                loadTransferable(from: newValue)
            }
        }
    }

    private func onUpdateProfile() {
        Task {
            isLoading = true
            await activeUser.updateProfile(
                username: username,
                fullName: fullName,
                website: website
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
