import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Profile Image (Larger Circle)
                Image("profile_image") // Replace with actual image asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150) // Increased size for the circle
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(radius: 4)
                
                // User Info (Styled like a list)
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(title: "Username:", value: "user123")
                    InfoRow(title: "Password:", value: "********")
                    InfoRow(title: "Donations Made:", value: "$150")
                    
                    // Change Username/Password Row (Styled like the rest)
                    NavigationLink(destination: ChangeCredentialsView()) {
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
                        .padding(.vertical, 5) // Adds spacing between rows for a nice list feel
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .foregroundColor(.black) // Ensures black text color for all user info
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    print("User Logged Out")
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
            // Title text with bold font
            Text(title)
                .font(.custom("AmericanTypewriter", size: 18))
                .fontWeight(.bold) // Bold title
                .foregroundColor(.black) // Updated to black
                .frame(maxWidth: .infinity, alignment: .leading) // Ensures alignment is left
            
            // Value text with regular font
            Text(value)
                .font(.custom("AmericanTypewriter", size: 18))
                .fontWeight(.regular) // Regular font for the value
                .foregroundColor(.black) // Ensures value text is black
                .frame(maxWidth: .infinity, alignment: .trailing) // Ensures alignment is right
        }
        .padding(.vertical, 5) // Adds spacing between rows for a nice list feel
    }
}
struct ChangeCredentialsView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var newUsername: String = ""
    @State private var successMessage: String = ""
    @State private var errorMessage: String = ""
    @State private var usernameError: String = ""
    @State private var passwordError: String = ""
    @State private var usernameSuccess: String = ""
    @State private var passwordSuccess: String = ""
    
    // Function to create a Color from a hex string
    func colorFromHex(hex: String) -> Color {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        
        // Ensure the hex is a valid 6-digit hex value (RGB)
        guard hexSanitized.count == 6 else {
            return Color.black // Return black color if invalid hex code
        }
        
        // Extract the RGB components from the hex string
        let redHex = String(hexSanitized.prefix(2))
        let greenHex = String(hexSanitized.dropFirst(2).prefix(2))
        let blueHex = String(hexSanitized.dropFirst(4).prefix(2))
        
        // Convert the hex string to Int values
        let red = Int(redHex, radix: 16) ?? 0
        let green = Int(greenHex, radix: 16) ?? 0
        let blue = Int(blueHex, radix: 16) ?? 0
        
        // Create a Color using the RGB values
        return Color(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: 1.0
        )
    }
    
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
                    
                    // Save Username Changes Button
                    Button(action: saveUsernameChanges) {
                        Text("Save Username")
                            .font(.custom("AmericanTypewriter", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colorFromHex(hex: "#c9ada7")) // Custom hex color for button
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Error and Success Messages for Username
                    if !usernameError.isEmpty {
                        Text(usernameError)
                            .foregroundColor(.red)
                            .font(.custom("AmericanTypewriter", size: 18))
                    }
                    
                    if !usernameSuccess.isEmpty {
                        Text(usernameSuccess)
                            .foregroundColor(.green)
                            .font(.custom("AmericanTypewriter", size: 18))
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
                    
                    // Save Password Changes Button
                    Button(action: savePasswordChanges) {
                        Text("Save Password")
                            .font(.custom("AmericanTypewriter", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colorFromHex(hex: "#c9ada7")) // Custom hex color for button
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Error and Success Messages for Password
                    if !passwordError.isEmpty {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.custom("AmericanTypewriter", size: 18))
                    }
                    
                    if !passwordSuccess.isEmpty {
                        Text(passwordSuccess)
                            .foregroundColor(.green)
                            .font(.custom("AmericanTypewriter", size: 18))
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
            usernameSuccess = "Username successfully updated!"
        }
        
        // Clear the username field after saving
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
        
        // Clear the password fields after saving
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
}

struct ChangeCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCredentialsView()
    }
}
// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
