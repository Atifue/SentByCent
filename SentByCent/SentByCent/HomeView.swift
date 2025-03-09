import SwiftUI

struct HomeView: View {
    @State private var selectedTab: String = "Home"
    @Binding var isLoggedIn: Bool
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    @ObservedObject var globalVars = GlobalVariables.shared // ✅ Observe changes

    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreen(transactionsViewModel: transactionsViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Home")

            AccountsView(transactionsViewModel: transactionsViewModel)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Accounts")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Accounts")

            CharityView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Charity")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Charity")

            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Profile")
        }
        .accentColor(.blue)
    }
}

// MARK: - Main Screen (Home Page)
struct MainScreen: View {
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    @ObservedObject var globalVars = GlobalVariables.shared // ✅ Observe GlobalVariables directly

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(red: 201/255, green: 173/255, blue: 167/255))
                            .frame(width: 250, height: 250)
                            .overlay(
                                VStack {
                                    // ✅ Observing `globalVars.savedAmount` so UI updates automatically
                                    Text("$\(String(format: "%.2f", globalVars.savedAmount))")
                                        .font(.custom("American Typewriter", size: 50))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)

                                    Text("Available to Donate")
                                        .font(.custom("American Typewriter", size: 18))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            )
                            .offset(y: 50)

                        Text("You Saved...")
                            .font(.custom("American Typewriter", size: 30))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .offset(y: -100)
                    }
                    .padding(.bottom, 40)

                    Text("Recent Transactions")
                        .font(.custom("American Typewriter", size: 24))
                        .fontWeight(.bold)
                        .padding(.top, 30)

                    VStack(spacing: 0) {
                        ForEach(transactionsViewModel.transactions, id: \.0) { transaction in
                            HStack {
                                Text(transaction.0)  // Transaction Description
                                    .font(.custom("American Typewriter", size: 18))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(transaction.1)  // Transaction Amount
                                    .font(.custom("American Typewriter", size: 18))
                                    .foregroundColor(.green)
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
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear {
                if let accountID = GlobalVariables.shared.account?.id {
                    transactionsViewModel.fetchTransactions(for: accountID)
                } else {
                    print("❌ Error: No account ID found")
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DonationMade"))) { _ in
                // Usually not needed, but can nudge SwiftUI to refresh:
                globalVars.objectWillChange.send()
            }
        }
    }
}
