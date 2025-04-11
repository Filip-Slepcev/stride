import Foundation
import PhotosUI
import Storage
import Supabase
import SwiftUI

struct Profile: Codable {
    let username: String?
    let fullName: String?
    let website: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case username
        case fullName = "full_name"
        case website
        case avatarURL = "avatar_url"
    }
}

class ActiveUser: ObservableObject {
    @Published var id: UUID?
    @Published var username: String?
    @Published var fullName: String?
    @Published var website: String?
    @Published var avatarURL: String?
    @Published var avatarImage: AvatarImage?
    @Published var loggedIn: Bool = false

    func initProfile(userId: UUID) async {

        guard let profile = await ProfileService.getProfile(userId: userId)
        else {
            return
        }

        await MainActor.run {
            self.id = userId
            self.username = profile.username
            self.fullName = profile.fullName
            self.website = profile.website
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

    func updateProfile(username: String?, fullName: String?, website: String?)
        async
    {
        await ProfileService.updateProfile(
            userId: self.id!,
            username: username,
            fullName: fullName,
            website: website
        )
    }

    func uploadImage(image: AvatarImage?) async throws {
        let filePath = await ProfileService.updateAvatar(
            userId: self.id!,
            image: image
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
            self.fullName = nil
            self.website = nil
            self.avatarURL = nil
            self.avatarImage = nil
            self.loggedIn = false
        }
    }
}
