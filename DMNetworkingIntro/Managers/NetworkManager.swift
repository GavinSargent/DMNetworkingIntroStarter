//
//  NetworkManager.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import Foundation

/**
 3.1 Create a protocol called `NetworkManagerDelegate` that contains a function called `usersRetrieved`.. This function should accept an array of `User` and should not return anything.
 */

//protocol NetworkManagerDelegate {
//    func usersRetrieved (user: [User])
//}


class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://reqres.in/api/"
    
    
    
    /**
     3.2 Create a variable called `delegate` of type optional `NetworkManagerDelegate`. We will be using the delegate to pass the `Users` to the `UsersViewController` once they come back from the API.
     */
//    var delegate: NetworkManagerDelegate?
    /**
     3.3 Makes a request to the API and decode the JSON that comes back into a `UserResponse` object.
     3.4 Call the `delegate`'s `usersRetrieved` function, passing the `data` array from the decoded `UserResponse`.
     
     This is a tricky function, so some starter code has been provided.
     */
    func getUsers(completionHandler: @escaping (Result<[User], DMError>) -> Void) {
        
        let urlString = "\(baseUrl)users"
        
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    completionHandler(.failure(.unableToComplete))
                    return
                }
                if data == nil {
                    print("No data returned")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedData = try decoder.decode(UserResponse.self, from: data!)
//                    self.delegate?.usersRetrieved(user: decodedData.data)
                    completionHandler(.success(decodedData.data))
                } catch {
                    completionHandler(.failure(.invalidData))
                    return
                }
            }
            
            task.resume()
        } else {
            completionHandler(.failure(.invalidURL))
            return
        }
    }
}
