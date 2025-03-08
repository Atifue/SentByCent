//
//  CharityView.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/8/25.
//

import SwiftUI

struct CharityView: View {
    @State private var charities = ["Red Cross", "World Wildlife Fund", "Doctors Without Borders", "UNICEF"]
    @State private var selectedCharity: String? = nil
    @State private var showingSentAlert: Bool = false
    @State private var donationAmount: String = "$0.00"
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
                            // Show the donation sheet when a charity is clicked
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
                    .onDelete(perform: deleteCharity) // Swipe to delete
                }
                .listStyle(PlainListStyle()) // Makes it look nicer

                Spacer()

                // "Add Charity" Button
                Button(action: {
                    // Show the slide-up view to add a new charity
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
                // Slide-up donation sheet
                DonationSheet(charity: selectedCharity ?? "Charity", donationAmount: $donationAmount, showingSentAlert: $showingSentAlert)
            }
            .sheet(isPresented: $showAddCharitySheet) {
                // Slide-up view for adding a new charity
                AddCharitySheet(newCharityName: $newCharityName, charities: $charities)
            }
        }
    }

    // Function to delete charity from the list
    func deleteCharity(at offsets: IndexSet) {
        charities.remove(atOffsets: offsets)
    }
}

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

            // Donation amount input field
            TextField("$0.00", text: $donationAmount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 40)
                .font(.custom("American Typewriter", size: 24))
                .frame(height: 80) // Increased height here
                .focused($isAmountFieldFocused)
                .onChange(of: donationAmount) { newValue in
                    // Format the donation input as $x.xx
                    if let amount = Double(newValue.replacingOccurrences(of: "$", with: "")) {
                        donationAmount = String(format: "$%.2f", amount)
                    } else {
                        donationAmount = "$0.00"
                    }
                }

            Spacer()

            // Send button
            Button(action: {
                showingSentAlert = true
                donationAmount = "$0.00" // Reset after donation is sent
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
        .background(Color.gray.opacity(0.1)) // Setting the entire background to gray
        .cornerRadius(30)
        .padding(.top, 50)
        .transition(.move(edge: .bottom)) // Slide-up transition
    }
}

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
                .frame(height: 80) // Increased height here

            Spacer()

            // Add Charity button
            Button(action: {
                if !newCharityName.isEmpty {
                    charities.append(newCharityName)
                    newCharityName = "" // Reset after adding
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
        .background(Color.gray.opacity(0.1)) // Setting the entire background to gray
        .cornerRadius(30)
        .padding(.top, 50)
        .transition(.move(edge: .bottom)) // Slide-up transition
    }
}

