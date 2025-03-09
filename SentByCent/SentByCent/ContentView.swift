import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = "" // For sign-up
    @State private var isLoggedIn: Bool = false
    @State private var isSignUp: Bool = false // To toggle between Log In and Sign Up
    @State private var loginError: String? = nil // To display error message
    @StateObject private var accountViewModel = AccountViewModel() // ✅ Use ViewModel
    @StateObject private var transactionsViewModel = TransactionsViewModel() // ✅ Track Transactions
    @ObservedObject var globalVars = GlobalVariables.shared // ✅ Observe GlobalVariables

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sent by Cent")
                    .font(.custom("American Typewriter", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 223/255, blue: 102/255))
                    .padding(.top, 120)
                    .frame(maxWidth: .infinity)
                
                Spacer().frame(height: 110)
                
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
                            if username.isEmpty || password.isEmpty {
                                loginError = "Username and Password cannot be empty."
                            } else {
                                print("🟡 Attempting login with customer_id:", password) // 🔍 Debug print
                                let customerID = password  // ✅ Customer ID stored in password
                                GlobalVariables.shared.username = username
                                
                                // Fetch accounts
                                accountViewModel.fetchAccounts(for: customerID)

                                // Wait for accounts to load, then fetch transactions
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    if let firstAccount = accountViewModel.accounts.first {
                                        GlobalVariables.shared.account = firstAccount  // ✅ Store in Global
                                        transactionsViewModel.fetchTransactions(for: firstAccount.id)

                                        // Wait for transactions to load, then update saved amount
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            GlobalVariables.shared.savedAmount = transactionsViewModel.totalSaved
                                            isLoggedIn = true
                                            loginError = nil
                                        }
                                    } else {
                                        loginError = "No accounts found for this customer."
                                    }
                                }
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
                .padding(.vertical, 50)
                .frame(width: 300)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))

                Spacer()
            }
            .padding(.top, -40)
            .background(Color(red: 201/255, green: 173/255, blue: 167/255).edgesIgnoringSafeArea(.all))
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView(isLoggedIn: $isLoggedIn, transactionsViewModel: transactionsViewModel) // ✅ Pass both values
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
