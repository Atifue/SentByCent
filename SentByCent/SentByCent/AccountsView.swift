import SwiftUI

struct AccountsView: View {
    @State private var accounts: [(String, String)] = []
    @State private var showingLinkAccountView = false  // ✅ Add back state for sheet
    
    // now transaction list is expected for accountDetails
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    

    var body: some View {
        NavigationView {
            VStack {
                Text("Linked Account")
                    .font(.custom("American Typewriter", size: 28))
                    .fontWeight(.bold)
                    .padding(.top, 20)

                List {
                    if let account = GlobalVariables.shared.account {
                        // ✅ Added NavigationLink to make the account clickable
                        NavigationLink( //added transactionView
                            destination: AccountDetailsView(account: account, transactionsViewModel: transactionsViewModel),
                            label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(account.nickname) // ✅ Display account nickname
                                            .font(.custom("American Typewriter", size: 20))
                                            .foregroundColor(.black)

                                        Text("**** \(String(account.account_number.suffix(4)))") // ✅ Show last 4 digits
                                            .font(.custom("American Typewriter", size: 16))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                        )
                    } else {
                        Text("No linked accounts found.")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .listStyle(InsetGroupedListStyle())

                Spacer()

                // ✅ Add back "Link an Account" button
                Button(action: {
                    showingLinkAccountView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Link an Account")
                            .font(.custom("American Typewriter", size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#c9ada7")) // Set background color using hex
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .shadow(color: Color(hex: "#c9ada7").opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 20)
                .sheet(isPresented: $showingLinkAccountView) {  // ✅ Show linking view
                    LinkAccountView(accounts: $accounts)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
} // ✅ Make sure AccountsView is properly closed

// MARK: - Link an Account Form (Adds New Account)
struct LinkAccountView: View {
    @Binding var accounts: [(String, String)]
    
    @State private var accountHolderName: String = ""
    @State private var accountNumber: String = ""
    @State private var bankName: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Link a New Account")
                    .font(.custom("American Typewriter", size: 24))
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                TextField("🏦 Bank Name", text: $bankName)
                    .font(.custom("American Typewriter", size: 18))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("👤 Account Holder Name", text: $accountHolderName)
                    .font(.custom("American Typewriter", size: 18))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("🔢 Account Number", text: $accountNumber)
                    .font(.custom("American Typewriter", size: 18))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.numberPad)
                
                Spacer()
                
                Button(action: {
                    if !bankName.isEmpty && !accountNumber.isEmpty {
                        let lastFour = String(accountNumber.suffix(4))
                        let newAccount = (bankName, "**** \(lastFour)")
                        accounts.append(newAccount)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Add Account")
                        .font(.custom("American Typewriter", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#c9ada7")) // Set background color using hex
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .shadow(color: Color(hex: "#c9ada7").opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// Hex color extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        var hexColor: UInt64 = 0
        scanner.scanHexInt64(&hexColor)
        let red = Double((hexColor & 0xFF0000) >> 16) / 255.0
        let green = Double((hexColor & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexColor & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
