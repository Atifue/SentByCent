import Foundation

class GlobalVariables: ObservableObject {
    static let shared = GlobalVariables() // ✅ Singleton instance
    
    @Published var username: String? = nil
    @Published var account: Account? = nil
    @Published var savedAmount: Double = 0.0
    @Published var totalDonated: Double = 0.0 // ✅ Make sure this exists

    private init() {} // Prevents multiple instances
}

