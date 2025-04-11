import Foundation

public enum Environment {
    enum Keys {
        static let SUPABASE_URL = ""
        static let SUPABASE_KEY = ""
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError(
                "Could not load info dictionary from bundle. Make sure you have embedded the Info.plist file in your target."
            )
        }
        return dict
    }()
    
    static let supaBaseURL: String = {
        guard let supaBaseUrl = infoDictionary["SUPABASE_URL"] as? String else {
            fatalError("SUPABASE_URL not found in Info.plist")
        }
        return supaBaseUrl
    }()
    
    static let supaBaseKey: String = {
        guard let supaBaseKey = infoDictionary["SUPABASE_KEY"] as? String else {
            fatalError("SUPABASE_KEY not found in Info.plist")
        }
        return supaBaseKey
    }()
}
