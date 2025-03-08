//
//  AccountsView.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/8/25.
//

import SwiftUI

struct AccountsView: View {
    @State private var accounts: [(String, String)] = [
        ("Chase Bank", "**** 1234"),
        ("Bank of America", "**** 5678"),
        ("Wells Fargo", "**** 9101")
    ]
    
    @State private var showingLinkAccountView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Linked Accounts")
                    .font(.custom("American Typewriter", size: 28))
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                List {
                    ForEach(accounts.indices, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(accounts[index].0)
                                    .font(.custom("American Typewriter", size: 20))
                                    .foregroundColor(.black)
                                
                                Text(accounts[index].1)
                                    .font(.custom("American Typewriter", size: 16))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete { indexSet in
                        accounts.remove(atOffsets: indexSet) // Delete accounts
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
                
                // Link an Account button
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
                .sheet(isPresented: $showingLinkAccountView) {
                    LinkAccountView(accounts: $accounts)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

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
