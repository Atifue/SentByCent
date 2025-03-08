import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = "" // For sign-up
    @State private var isLoggedIn: Bool = false
    @State private var isSignUp: Bool = false // To toggle between Log In and Sign Up
    @State private var loginError: String? = nil // To display error message

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sent by Cent")
                    .font(.custom("American Typewriter", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 223/255, blue: 102/255)) // Dim Yellow
                    .padding(.top, 120) // Lowered title
                    .frame(maxWidth: .infinity)
                
                Spacer().frame(height: 110) // Reduced spacer to move box higher
                
                VStack(spacing: 20) {
                    if isSignUp {
                        Text("Sign Up")
                            .font(.custom("American Typewriter", size: 24))
                            .fontWeight(.semibold)

                        TextField("Username", text: $username)
                            .font(.custom("American Typewriter", size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        SecureField("Password", text: $password)
                            .font(.custom("American Typewriter", size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .font(.custom("American Typewriter", size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button("Sign Up") {
                            isLoggedIn = true
                        }
                        .font(.custom("American Typewriter", size: 18))
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else {
                        Text("Welcome!")
                            .font(.custom("American Typewriter", size: 24))
                            .fontWeight(.semibold)

                        TextField("Username", text: $username)
                            .font(.custom("American Typewriter", size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        SecureField("Password", text: $password)
                            .font(.custom("American Typewriter", size: 18))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        if let loginError = loginError {
                            Text(loginError)
                                .font(.custom("American Typewriter", size: 16))
                                .foregroundColor(.red)
                        }

                        Button("Log In") {
                            if username.lowercased() == "fox" {
                                isSignUp = true
                            } else if username.isEmpty || password.isEmpty {
                                loginError = "Username and Password cannot be empty."
                            } else {
                                isLoggedIn = true
                                loginError = nil
                            }
                        }
                        .font(.custom("American Typewriter", size: 18))
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Button(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                        isSignUp.toggle()
                    }
                    .font(.custom("American Typewriter", size: 18))
                    .foregroundColor(.blue)
                }
                .padding(.vertical, 50) // Box height remains
                .frame(width: 300) // Box remains narrow
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))

                Spacer()
            }
            .padding(.top, -40) // Moves the whole content slightly up
            .background(Color(red: 201/255, green: 173/255, blue: 167/255).edgesIgnoringSafeArea(.all)) // Background color
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}




//import SwiftUI
//
//struct ContentView: View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = "" // For sign-up
//    @State private var isLoggedIn: Bool = false
//    @State private var isSignUp: Bool = false // To toggle between Log In and Sign Up
//    @State private var loginError: String? = nil // To display error message
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Sent by Cent")
//                    .font(.custom("American Typewriter", size: 40))
//                    .fontWeight(.bold)
//                    .foregroundColor(Color(red: 255/255, green: 223/255, blue: 102/255)) // Dim Yellow
//                    .padding(.top, 70) // Lowered title
//                    .frame(maxWidth: .infinity)
//
//                Spacer()
//
//                VStack(spacing: 20) {
//                    if isSignUp {
//                        Text("Sign Up")
//                            .font(.custom("American Typewriter", size: 24))
//                            .fontWeight(.semibold)
//
//                        TextField("Username", text: $username)
//                            .font(.custom("American Typewriter", size: 18))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.horizontal)
//
//                        SecureField("Password", text: $password)
//                            .font(.custom("American Typewriter", size: 18))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.horizontal)
//
//                        SecureField("Confirm Password", text: $confirmPassword)
//                            .font(.custom("American Typewriter", size: 18))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.horizontal)
//
//                        Button("Sign Up") {
//                            isLoggedIn = true
//                        }
//                        .font(.custom("American Typewriter", size: 18))
//                        .frame(width: 200, height: 50)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    } else {
//                        Text("Welcome!")
//                            .font(.custom("American Typewriter", size: 24))
//                            .fontWeight(.semibold)
//
//                        TextField("Username", text: $username)
//                            .font(.custom("American Typewriter", size: 18))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.horizontal)
//
//                        SecureField("Password", text: $password)
//                            .font(.custom("American Typewriter", size: 18))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.horizontal)
//
//                        if let loginError = loginError {
//                            Text(loginError)
//                                .font(.custom("American Typewriter", size: 16))
//                                .foregroundColor(.red)
//                        }
//
//                        Button("Log In") {
//                            if username.lowercased() == "fox" {
//                                isSignUp = true
//                            } else if username.isEmpty || password.isEmpty {
//                                loginError = "Username and Password cannot be empty."
//                            } else {
//                                isLoggedIn = true
//                                loginError = nil
//                            }
//                        }
//                        .font(.custom("American Typewriter", size: 18))
//                        .frame(width: 200, height: 50)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//
//                    Button(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
//                        isSignUp.toggle()
//                    }
//                    .font(.custom("American Typewriter", size: 18))
//                    .foregroundColor(.blue)
//                }
//                .padding(.vertical, 70) // Increased height for the box
//                .frame(width: 300) // Kept it narrow
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
//
//                Spacer()
//            }
//            .padding()
//            .background(Color(red: 201/255, green: 173/255, blue: 167/255).edgesIgnoringSafeArea(.all)) // Background color
//            .navigationDestination(isPresented: $isLoggedIn) {
//                HomeView()
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//}
