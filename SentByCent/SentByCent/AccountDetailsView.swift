import SwiftUI

struct AccountDetailsView: View {
    var account: Account // Account passed from previous view
    @ObservedObject var transactionsViewModel: TransactionsViewModel

    var body: some View {
        ScrollView { // Make the whole page scrollable
            VStack(alignment: .leading) {
                // Account details at the top with a beige background and smaller font
                VStack {
                    HStack {
                        Text("  Checking")
                            .font(.custom("American Typewriter", size: 18)) // Smaller font for 'Checking'
                            .fontWeight(.bold) // Bold 'Checking'
                        
                        Spacer() // Spacer to push the account number to the right

                        Text("xxx-\(String(account.account_number.suffix(4)))") // Display as xxx-last 4 digits
                            .font(.custom("American Typewriter", size: 16)) // Smaller font for account number
                            .fontWeight(.regular) // Regular weight for account number
                            .padding(.trailing, 8)
                    }
                    .padding(.vertical, 8) // Reduced padding
                    .frame(maxWidth: 280) // Make the box narrower
                    .background(Color(red: 201/255, green: 173/255, blue: 167/255)) // Beige background
                    .cornerRadius(12) // Smaller corner radius
                    .padding(.horizontal, 16)
                    .shadow(radius: 2) // Optional shadow for a cute effect
                    .frame(maxWidth: .infinity) // Center the title box
                }
                .padding(.top, 10) // Reduced top padding
                
                // Account Balance Section with centered box and increased height
                VStack {
                    Text("Account Balance")
                        .font(.custom("American Typewriter", size: 18)) // Slightly smaller font
                        .foregroundColor(.black) // Account Balance title in black
                        .fontWeight(.bold)
                        .padding(.top, 8) // Reduced top padding
                        .padding(.bottom, 6) // Reduced bottom padding
                    
                    Text("$\(String(format: "%.2f", account.balance))")
                        .font(.custom("American Typewriter", size: 30)) // Slightly larger font for balance
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Balance number in white
                        .padding(.vertical, 40) // Increased vertical padding for taller box
                        .frame(maxWidth: 280) // Keep the box narrower but taller
                        .background(Color(red: 201/255, green: 173/255, blue: 167/255)) // Soft background color
                        .cornerRadius(15) // Smaller corner radius
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity) // Center the balance box
                }
                .padding(.top, 20)

                // "Transactions" Section
                Text("Transactions")
                    .font(.custom("American Typewriter", size: 22)) // Slightly smaller title font
                    .fontWeight(.bold)
                    .padding(.top, 20) // Reduced top padding
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .center) // Center the title

                // List of real (unrounded) transactions
                VStack(spacing: 0) {
                    ForEach(transactionsViewModel.realTransactions, id: \.0) { transaction in
                        HStack {
                            Text(transaction.0) // Transaction Description
                                .font(.custom("American Typewriter", size: 18))
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", transaction.1))") // Actual Amount
                                .font(.custom("American Typewriter", size: 18))
                                .foregroundColor(.green) // Transaction amounts in green
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            Divider().background(Color.gray.opacity(0.5)), alignment: .bottom
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal, 16)
                .padding(.bottom, 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full-width content
        }
        .navigationTitle("Account Details")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            transactionsViewModel.fetchTransactionsReal(for: account.id) // Fetch real transactions
        }
    }
}
