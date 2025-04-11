import Foundation
import Supabase



let supabase = SupabaseClient(
    supabaseURL: URL(string: Environment.supaBaseURL)!,
    supabaseKey: Environment.supaBaseKey
)
