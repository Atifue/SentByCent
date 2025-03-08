import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [(String, String)] = []  // Stores (description, rounded-up cents) as a list
    @Published var totalSaved: Double = 0.0  // Stores the total rounded-up cents

    func fetchTransactions(for accountID: String) {
        guard let url = URL(string: "http://api.nessieisreal.com/accounts/\(accountID)/purchases?key=2e0c94f409f596fcf845593ff5e6d409") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return } // Ensure self is available
            
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
                    // Reset total saved to 0 before recalculating
                    self.totalSaved = 0.0
                    
                    // Process each transaction, calculate the rounded-up change, and add to totalSaved
                    self.transactions = decodedTransactions.map { purchase in
                        let change = self.calculateChange(for: purchase.amount)
                        self.totalSaved += change  // Accumulate the rounded-up change
                        return (purchase.description, "+$\(String(format: "%.2f", change))")
                    }
                }
            } catch {
                print("Error decoding transactions: \(error)")
            }
        }
        task.resume()
    }

    // Function to calculate the spare change needed to round up the transaction
    func calculateChange(for amount: Double) -> Double {
        let roundedAmount = ceil(amount)  // Round up to nearest whole number
        let change = roundedAmount - amount  // Calculate the spare change
        return change
    }
}
