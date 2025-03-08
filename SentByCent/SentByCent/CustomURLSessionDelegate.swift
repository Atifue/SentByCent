import Foundation

class CustomURLSessionDelegate: NSObject, URLSessionDelegate {
    // This function handles the authentication challenges, allowing the connection to proceed
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Safely unwrap the server trust
        if let serverTrust = challenge.protectionSpace.serverTrust {
            // Trust the server, bypassing ATS checks
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            // If serverTrust is nil, cancel the request or handle the error accordingly
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
