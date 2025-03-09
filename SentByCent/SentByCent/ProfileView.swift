import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool // ✅ Binding to control logout navigation
    @State private var username: String = GlobalVariables.username ?? "Unknown" // ✅ Track username updates

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Profile Image (Larger Circle)
                Image("profile_image") // Replace with actual image asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(radius: 4)
                
                // User Info
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(title: "Username:", value: username) // ✅ Dynamic username update
                    InfoRow(title: "Password:", value: "********")
                    InfoRow(title: "Donations Made:", value: "$150")
                    
                    // Change Credentials Navigation
                    NavigationLink(destination: ChangeCredentialsView(username: $username)) { // ✅ Pass binding
                        HStack {
                            Text("Change username or password")
                                .font(.custom("AmericanTypewriter", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(">")
                                .font(.custom("AmericanTypewriter", size: 18))
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .foregroundColor(.black)
                
                Spacer()
                
                // Logout Button ✅ (Navigates Back to ContentView)
                Button(action: {
                    isLoggedIn = false // ✅ Logs out user and returns to login
                }) {
                    Text("Logout")
                        .font(.custom("AmericanTypewriter", size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding(.top, 40)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6))
            .navigationBarHidden(true)
        }
    }
}

// Information Row Component
struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AmericanTypewriter", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .font(.custom("AmericanTypewriter", size: 18))
                .fontWeight(.regular)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Change Credentials View
struct ChangeCredentialsView: View {
    @Binding var username: String // ✅ Binding to update ProfileView
    @State private var newUsername: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var usernameSuccess: String = ""
    @State private var usernameError: String = ""
    @State private var passwordSuccess: String = ""
    @State private var passwordError: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Change Username or Password")
                    .font(.custom("AmericanTypewriter", size: 24))
                    .padding(.top)
                
                // Username Section
                VStack(alignment: .leading) {
                    Text("New Username:")
                        .font(.custom("AmericanTypewriter", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    TextField("Enter new username", text: $newUsername)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .font(.custom("AmericanTypewriter", size: 18))
                    
                    Button(action: saveUsernameChanges) {
                        Text("Save Username")
                            .font(.custom("AmericanTypewriter", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Error/Success Messages
                    if !usernameError.isEmpty {
                        Text(usernameError).foregroundColor(.red).font(.custom("AmericanTypewriter", size: 18))
                    }
                    if !usernameSuccess.isEmpty {
                        Text(usernameSuccess).foregroundColor(.green).font(.custom("AmericanTypewriter", size: 18))
                    }
                }
                .padding(.horizontal, 40)
                
                Divider().padding(.vertical)
                
                // Password Section
                VStack(alignment: .leading) {
                    Text("Current Password:")
                        .font(.custom("AmericanTypewriter", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    SecureField("Enter current password", text: $currentPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .font(.custom("AmericanTypewriter", size: 18))
                    
                    Text("New Password:")
                        .font(.custom("AmericanTypewriter", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    SecureField("Enter new password", text: $newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .font(.custom("AmericanTypewriter", size: 18))
                    
                    Text("Confirm New Password:")
                        .font(.custom("AmericanTypewriter", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    SecureField("Confirm new password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .font(.custom("AmericanTypewriter", size: 18))
                    
                    Button(action: savePasswordChanges) {
                        Text("Save Password")
                            .font(.custom("AmericanTypewriter", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Error/Success Messages
                    if !passwordError.isEmpty {
                        Text(passwordError).foregroundColor(.red).font(.custom("AmericanTypewriter", size: 18))
                    }
                    if !passwordSuccess.isEmpty {
                        Text(passwordSuccess).foregroundColor(.green).font(.custom("AmericanTypewriter", size: 18))
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Credentials")
        }
    }
    
    // Save Username Changes
    func saveUsernameChanges() {
        if newUsername.isEmpty {
            usernameError = "Username cannot be empty!"
            usernameSuccess = ""
        } else {
            usernameError = ""
            username = newUsername // ✅ Updates ProfileView
            GlobalVariables.username = newUsername // ✅ Updates globally
            usernameSuccess = "Username successfully updated!"
        }
        newUsername = ""
    }

    // Save Password Changes
    func savePasswordChanges() {
        if currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            passwordError = "All password fields are required!"
            passwordSuccess = ""
        } else if newPassword != confirmPassword {
            passwordError = "Passwords do not match!"
            passwordSuccess = ""
        } else {
            passwordError = ""
            passwordSuccess = "Password successfully updated!"
        }
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
}
