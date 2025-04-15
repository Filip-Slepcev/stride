import Foundation
import PhotosUI
import Storage
import Supabase
import SwiftUI

struct Profile: Codable {
    let id: UUID
    let username: String?
    let bio: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case bio
        case avatarURL = "avatar_url"
    }
}

class ActiveUser: ObservableObject {
    @Published var id: UUID?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarURL: String?
    @Published var avatarImage: AvatarImage?
    @Published var loggedIn: Bool = false

    func login(userId: UUID) async {
        guard let profile = await ProfileService.getProfile(userId: userId)
        else {
            return
        }

        await MainActor.run {
            self.id = userId
            self.username = profile.username
            self.bio = profile.bio
            self.avatarURL = profile.avatarURL
            self.loggedIn = true
        }

        if let avatarURL = profile.avatarURL, !avatarURL.isEmpty {
            let image = await ProfileService.getProfileAvatar(
                avatarURL: avatarURL
            )
            await MainActor.run {
                self.avatarImage = image
            }
        }
    }

    func updateProfile(username: String?, bio: String?)
        async
    {
        await ProfileService.updateProfile(
            userId: self.id!,
            username: username,
            bio: bio
        )
    }

    func uploadImage(image: AvatarImage?) async throws {
        let filePath = await ProfileService.updateAvatar(
            userId: self.id!,
            image: image,
            oldImageUrl: self.avatarURL
        )
        await MainActor.run {
            self.avatarURL = filePath
            self.avatarImage = image
        }
    }

    func logout() async {
        try? await supabase.auth.signOut()

        await MainActor.run {
            self.id = nil
            self.username = nil
            self.bio = nil
            self.avatarURL = nil
            self.avatarImage = nil
            self.loggedIn = false
        }
    }
}
