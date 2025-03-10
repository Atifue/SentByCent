import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [(String, String)] = []  // Stores (description, rounded-up cents) as a list
    @Published var totalSaved: Double = 0.0  // Stores the total rounded-up cents
    @Published var realTransactions: [(String, Double)] = []  // Stores (description, original amount) as a list
    @Published var roundedSavings: Double = 0.0  // Stores the total amount saved from rounding
    @Published var totalDonations: Double = GlobalVariables.shared.totalDonated  // Tracks total donated amount

    // Fetch and process transactions with rounding logic
    func fetchTransactions(for accountID: String) {
        guard let url = URL(string: "http://api.nessieisreal.com/accounts/\(accountID)/purchases?key=2e0c94f409f596fcf845593ff5e6d409") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return } // Ensure self is still around
            
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
                    // 1) Recalculate the total saved from rounding
                    self.totalSaved = 0.0
                    self.transactions = decodedTransactions.map { purchase in
                        let change = self.calculateChange(for: purchase.amount)
                        self.totalSaved += change
                        return (purchase.description, "+$\(String(format: "%.2f", change))")
                    }

                    // 2) Subtract whatever has already been donated
                    //    so the bubble reflects net leftover
                    let totalDonatedSoFar = GlobalVariables.shared.totalDonated
                    self.totalSaved -= totalDonatedSoFar

                    // 3) Prevent negative "savedAmount" if totalDonations exceed the round-up sum
                    if self.totalSaved < 0 {
                        self.totalSaved = 0
                    }

                    // 4) Update GlobalVariables
                    GlobalVariables.shared.savedAmount = self.totalSaved
                    self.roundedSavings = self.totalSaved
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
        let change = roundedAmount - amount
        return change
    }

    // Fetch transactions without rounding (raw transactions)
    func fetchTransactionsReal(for accountID: String) {
        guard let url = URL(string: "http://api.nessieisreal.com/accounts/\(accountID)/purchases?key=2e0c94f409f596fcf845593ff5e6d409") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

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
                    self.realTransactions = decodedTransactions.map { purchase in
                        // No rounding here—just store the raw data
                        return (purchase.description, purchase.amount)
                    }
                }
            } catch {
                print("Error decoding transactions: \(error)")
            }
        }
        task.resume()
    }

    // Function to handle donations
    func donate(amount: Double) -> Bool {
        guard amount > 0 else {
            print("Invalid donation amount.")
            return false
        }

        if amount > GlobalVariables.shared.savedAmount {
            print("Not enough funds in saved amount to donate.")
            return false
        }

        DispatchQueue.main.async {
            GlobalVariables.shared.savedAmount -= amount
            GlobalVariables.shared.totalDonated += amount
            self.totalDonations = GlobalVariables.shared.totalDonated
            print("Donated $\(amount). New saved amount: \(GlobalVariables.shared.savedAmount)")
        }
        
        return true
    }
}
