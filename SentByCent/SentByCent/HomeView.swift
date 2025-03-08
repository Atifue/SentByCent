import SwiftUI

struct HomeView: View {
    @State private var selectedTab: String = "Home"

    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Home")

            AccountsView()
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
/*
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .font(.custom("American Typewriter", size: 14))
                }
                .tag("Profile") */
        }
        .accentColor(.blue)
    }
}

struct MainScreen: View {
    let transactions = [
        ("Starbucks", "+$5.50"),
        ("Amazon", "+$120.99"),
        ("Walmart", "+$45.20"),
        ("Target", "+$30.75"),
        ("Uber", "+$10.00"),
        ("Apple Store", "+$200.00"),
        ("Nike", "+$75.50"),
        ("Best Buy", "+$150.00"),
        ("McDonald's", "+$7.90"),
        ("Netflix", "+$13.99")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(red: 201/255, green: 173/255, blue: 167/255))
                            .frame(width: 250, height: 250)
                            .overlay(
                                Text("$320.50")
                                    .font(.custom("American Typewriter", size: 50))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .offset(y: 50)

                        Text("You Saved...")
                            .font(.custom("American Typewriter", size: 30))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .offset(y: -100)
                    }
                    .padding(.bottom, 40)

                    Text("Transactions")
                        .font(.custom("American Typewriter", size: 24))
                        .fontWeight(.bold)
                        .padding(.top, 30)

                    VStack(spacing: 0) {
                        ForEach(transactions, id: \.0) { transaction in
                            HStack {
                                Text(transaction.0)
                                    .font(.custom("American Typewriter", size: 18))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(transaction.1)
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
        }
    }
}
