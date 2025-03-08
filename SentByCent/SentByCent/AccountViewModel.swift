import Foundation

class AccountViewModel: ObservableObject {
    @Published var accounts: [Account] = []

    // Modify the fetchAccounts method to accept a customerID as a parameter
    func fetchAccounts(for customerID: String) {
        let urlString = "http://api.nessieisreal.com/customers/\(customerID)/accounts?key=2e0c94f409f596fcf845593ff5e6d409"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Making the network request to fetch the accounts
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching accounts: \(error.localizedDescription)")
                return
            }

            if let data = data {
                // Parse the response data here
                if let accounts = try? JSONDecoder().decode([Account].self, from: data) {
                    DispatchQueue.main.async {
                        self.accounts = accounts
                    }
                } else {
                    print("Error decoding accounts data")
                }
            }
        }

        task.resume()
    }
}
