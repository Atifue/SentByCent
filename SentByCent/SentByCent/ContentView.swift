import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isSignUp: Bool = false
    @State private var loginError: String? = nil
    @StateObject private var accountViewModel = AccountViewModel()
    @StateObject private var transactionsViewModel = TransactionsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // App Title with a bubbly, bigger font
                Text("SentByCent")
                    .font(.custom("Pacifico", size: 50)) // Smaller, bubbly font
                    .foregroundColor(.black) // Yellow text color
                    .padding(10)
                    
                    
                
                // Custom Icon Asset
                Image("Subject") // Replace with your asset name "icon"
                    .resizable()
                    .frame(width: 120, height: 120) // Customizable size
                    .padding(.bottom, 20)
                
                // Input fields
                VStack(spacing: 12) { // Reduced spacing for a sleeker look
                    if isSignUp {
                        TextField(" Username", text: $username) // Added space before "Username"
                            .inputStyle()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                        
                        SecureField(" Password", text: $password) // Added space before "Password"
                            .inputStyle()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))

                        SecureField(" Confirm Password", text: $confirmPassword) // Added space before "Confirm Password"
                            .inputStyle()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))

                        PrimaryButton(title: "Sign Up") {
                            isLoggedIn = true
                        }
                    } else {
                        TextField(" Username", text: $username) // Added space before "Username"
                            .inputStyle()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))

                        SecureField(" Password", text: $password) // Added space before "Password"
                            .inputStyle()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))

                        if let loginError = loginError {
                            Text(loginError)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }

                        PrimaryButton(title: "Log In") {
                            handleLogin()
                        }
                    }
                }
                .padding(.vertical, 20) // Less padding for a sleeker box
                .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.2))) // Transparent background with opacity
                .padding(.horizontal) // More balanced horizontal padding
                
                // Toggle between Log In and Sign Up
                Button(action: { isSignUp.toggle() }) {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 230/255, green: 204/255, blue: 190/255), Color(red: 210/255, green: 180/255, blue: 165/255)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView(isLoggedIn: $isLoggedIn, transactionsViewModel: transactionsViewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func handleLogin() {
        if username.isEmpty || password.isEmpty {
            loginError = "Please fill out all fields."
        } else {
            accountViewModel.fetchAccounts(for: password)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let firstAccount = accountViewModel.accounts.first {
                    GlobalVariables.shared.account = firstAccount
                    isLoggedIn = true
                    loginError = nil
                } else {
                    loginError = "Invalid credentials."
                }
            }
        }
    }
}

extension View {
    func inputStyle() -> some View {
        self
            .padding(.vertical, 10) // Reduced padding for sleeker input fields
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6).opacity(0.2))) // Light background with opacity
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1)) // Black border
            .padding(.horizontal, 20) // Added padding on the horizontal axis for spacing
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .background(Color.yellow.opacity(0.6)) // Soft yellow background
                .cornerRadius(25) // Circular button
                .font(.system(size: 18, weight: .semibold))
        }
        .frame(width: 200, height: 50) // Reduced width for a narrower button
    }
}
