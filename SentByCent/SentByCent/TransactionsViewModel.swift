//
//  TransactionsViewModel.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/8/25.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [(String, String)] = []  // Stores (description, amount) as a list
    
    func fetchTransactions(for accountID: String) {
        guard let url = URL(string: "http://api.nessieisreal.com/accounts/\(accountID)/purchases?key=2e0c94f409f596fcf845593ff5e6d409") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)  // ✅ Fix ambiguity issue
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedTransactions = try JSONDecoder().decode([Purchase].self, from: data)
                DispatchQueue.main.async {
                    self.transactions = decodedTransactions.map {
                        ($0.description, "+$\(String(format: "%.2f", $0.amount))")
                    }
                }
            } catch {
                print("Error decoding transactions: \(error)")
            }
        }
        task.resume()  // ✅ Fix ambiguity issue
    }
}
