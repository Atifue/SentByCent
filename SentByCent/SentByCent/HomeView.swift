import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            // Big Circle for total saved
            VStack {
                Text("You Saved")
                    .font(.title)
                    .padding(.top, 20)
                
                Circle()
                    .strokeBorder(Color.blue, lineWidth: 10)
                    .frame(width: 150, height: 150)
                    .overlay(
                        Text("$0.00")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    )
                    .padding(.top, 50)
            }
            
            // Transaction List
            List {
                Text("Transaction 1")
                Text("Transaction 2")
                Text("Transaction 3")
            }
            .padding(.top, 20)
            
            // Bottom Buttons
            HStack {
                Button("Profile") {
                    // Action for Profile
                }
                .padding()
                
                Button("Bank Account") {
                    // Action for Bank Account
                }
                .padding()
                
                Button("Home") {
                    // Action for Home
                }
                .padding()
            }
            .padding(.top, 40)
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

