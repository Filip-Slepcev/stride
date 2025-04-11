import Foundation
import Storage
import SwiftUI

struct ProfileService {
    static func getProfile(userId: UUID) async -> Profile? {
        do{
            let profile: Profile =
            try await supabase
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return profile
        }catch {
            return nil
        }
    }
    
    static func getProfileAvatar(avatarURL: String) async -> AvatarImage? {
        do{
            let data = try await supabase.storage.from("avatars").download(path: avatarURL)
            return AvatarImage(data: data)
        }catch {
            return nil
        }
    }
    
    static func updateProfile(userId: UUID, username: String?, fullName: String?, website: String?)
        async
    {
        do {
            try await supabase
                .from("profiles")
                .update([
                    "username": username, "full_name": fullName,
                    "website": website,
                ])
                .eq("id", value: userId)
                .execute()
        } catch {
            debugPrint(error)
        }
    }
    
    static func updateAvatar(userId: UUID, image: AvatarImage?) async -> String? {
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
