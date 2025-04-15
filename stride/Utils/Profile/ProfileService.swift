import Foundation
import Storage
import SwiftUI

enum ProfileService {
    static func getProfile(userId: UUID) async -> Profile? {
        do {
            let profile: Profile =
                try await supabase
                    .from("profiles")
                    .select()
                    .eq("id", value: userId)
                    .single()
                    .execute()
                    .value
            
            return profile
        } catch {
            return nil
        }
    }
    
    static func getProfileAvatar(avatarURL: String) async -> AvatarImage? {
        do {
            let data = try await supabase.storage.from("avatars").download(path: avatarURL)
            return AvatarImage(data: data)
        } catch {
            return nil
        }
    }
    
    static func updateProfile(userId: UUID, username: String?, bio: String?)
        async
    {
        do {
            try await supabase
                .from("profiles")
                .update([
                    "username": username,
                    "bio": bio,
                ])
                .eq("id", value: userId)
                .execute()
        } catch {
            debugPrint(error)
        }
    }
    
    static func updateAvatar(userId: UUID, image: AvatarImage?, oldImageUrl: String?) async -> String? {
        do {
            guard let data = image?.data else { return nil }
            
            let filePath = "\(UUID().uuidString).jpeg"
            
            try await supabase.storage
                .from("avatars")
                .upload(
                    filePath,
                    data: data,
                    options: FileOptions(contentType: "image/jpeg")
                )
            if let oldImageUrl = oldImageUrl {
                try await supabase.storage.from("avatars").remove(paths: [oldImageUrl])
            }
            try await supabase
                .from("profiles")
                .update(["avatar_url": filePath])
                .eq("id", value: userId)
                .execute()
            
            return filePath
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
