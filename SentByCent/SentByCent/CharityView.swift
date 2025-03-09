import SwiftUI

struct CharityView: View {
    @State private var charities = ["Red Cross", "World Wildlife Fund", "Doctors Without Borders", "UNICEF"]
    @State private var selectedCharity: String? = nil
    @State private var showingSentAlert: Bool = false
    @State private var donationAmount: String = ""
    @State private var showDonationSheet: Bool = false
    @State private var showAddCharitySheet: Bool = false
    @State private var newCharityName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Charities")
                    .font(.custom("American Typewriter", size: 28))
                    .fontWeight(.bold)
                    .padding(.top, 20)

                List {
                    ForEach(charities, id: \.self) { charity in
                        Button(action: {
                            selectedCharity = charity
                            showDonationSheet = true
                        }) {
                            HStack {
                                Text(charity)
                                    .font(.custom("American Typewriter", size: 20))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5)
                        }
                    }
                    .onDelete(perform: deleteCharity)
                }
                .listStyle(PlainListStyle())

                Spacer()

                // ✅ "Add Charity" Button
                Button(action: {
                    showAddCharitySheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Add a Charity")
                            .font(.custom("American Typewriter", size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 201/255, green: 173/255, blue: 167/255))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .alert(isPresented: $showingSentAlert) {
                Alert(title: Text("Donation Sent"), message: Text("Your donation has been sent successfully!"), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showDonationSheet) {
                DonationSheet(charity: selectedCharity ?? "Charity", donationAmount: $donationAmount, showingSentAlert: $showingSentAlert)
            }
            .sheet(isPresented: $showAddCharitySheet) {
                AddCharitySheet(newCharityName: $newCharityName, charities: $charities)
            }
        }
    }

    func deleteCharity(at offsets: IndexSet) {
        charities.remove(atOffsets: offsets)
    }
}

// MARK: - **Donation Sheet**
struct DonationSheet: View {
    var charity: String
    @Binding var donationAmount: String
    @Binding var showingSentAlert: Bool
    @Environment(\.presentationMode) var presentationMode

    @FocusState private var isAmountFieldFocused: Bool

    var body: some View {
        VStack {
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
            }

            // Title for donation
            Text("Donate to \(charity)")
                .font(.custom("American Typewriter", size: 24))
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Spacer()

            // ✅ Donation Amount Input
            TextField("Enter amount", text: $donationAmount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 40)
                .font(.custom("American Typewriter", size: 24))
                .frame(height: 60)
                .focused($isAmountFieldFocused)
                .onChange(of: donationAmount) { newValue in
                    donationAmount = newValue.filter { "0123456789.".contains($0) } // Allow only numbers
                }
                .onSubmit {
                    if let amount = Double(donationAmount), amount > 0 {
                        donationAmount = String(format: "%.2f", amount)
                    } else {
                        donationAmount = "0.00"
                    }
                }

            Spacer()

            // ✅ Send button with proper updates
            Button(action: {
                if let amount = Double(donationAmount), amount > 0 {
                    if amount > GlobalVariables.shared.savedAmount {
                        showingSentAlert = false // Not enough funds
                    } else {
                        // ✅ Update Global Variables
                        GlobalVariables.shared.savedAmount -= amount
                        GlobalVariables.shared.totalDonated += amount

                        // ✅ Notify Profile + Home that values changed
                        NotificationCenter.default.post(name: NSNotification.Name("DonationMade"), object: nil)

                        showingSentAlert = true
                    }
                }
                donationAmount = ""
            }) {
                Text("Send")
                    .font(.custom("American Typewriter", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 201/255, green: 173/255, blue: 167/255))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom, 20)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(30)
        .padding(.top, 50)
        .transition(.move(edge: .bottom))
    }
}

// MARK: - **Add Charity Sheet**
struct AddCharitySheet: View {
    @Binding var newCharityName: String
    @Binding var charities: [String]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Close Button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
            }

            Text("Add a New Charity")
                .font(.custom("American Typewriter", size: 24))
                .fontWeight(.bold)
                .padding(.top, 10)

            Spacer()

            // TextField for new charity name
            TextField("Enter charity name", text: $newCharityName)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 40)
                .font(.custom("American Typewriter", size: 20))
                .frame(height: 80)

            Spacer()

            // ✅ Add Charity button
            Button(action: {
                if !newCharityName.isEmpty {
                    charities.append(newCharityName)
                    newCharityName = ""
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Add Charity")
                    .font(.custom("American Typewriter", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 201/255, green: 173/255, blue: 167/255))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom, 20)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(30)
        .padding(.top, 50)
        .transition(.move(edge: .bottom))
    }
}
