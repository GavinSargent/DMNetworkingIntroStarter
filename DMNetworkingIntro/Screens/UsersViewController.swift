//
//  UsersViewController.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import UIKit

/**
 1. Create the user interface. See the provided screenshot for how the UI should look.
 2. Follow the instructions in the `User` file.
 3. Follow the instructions in the `NetworkManager` file.
 */
class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    /**
     4. Create a variable called `users` and set it to an empty array of `User` objects.
     */
    var users: [User] = []
//    let tempArr: [Int] = [1,2,3,4,5]
    /**
     5. Connect the UITableView to the code. Create a function called `configureTableView` that configures the table view. You may find the `Constants` file helpful. Make sure to call the function in the appropriate spot.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getUsers()
    }
    
    /**
     6.1 Set the `NetworkManager`'s delegate property to the `UsersViewController`. Have the `UsersViewController` conform to the `NetworkManagerDelegate` protocol. In the `usersRetrieved` function, assign the `users` property to the array we got back from the API and call `reloadData` on the table view.
     */
    
    func getUsers(){
//        NetworkManager.shared.delegate = self
        NetworkManager.shared.getUsers(){ [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                usersRetrieved(user: user)
                    
            case .failure(let error):
                presentAlert(error: error)
            }
        }

    }
    
    func configureTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    func presentAlert (error: DMError) {
        let alert = UIAlertController(title: "Error", message: "\(DMError.RawValue.self)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func usersRetrieved(user: [User]) {
         users = user
        
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
         
 //        print(users)
     }
}

//MARK: - NetworkManagerDelegate

//extension UsersViewController: NetworkManagerDelegate {
//
//    func usersRetrieved(user: [User]) {
//         users = user
//
//        DispatchQueue.main.async {
//            self.usersTableView.reloadData()
//        }
//
// //        print(users)
//     }
//}

//MARK: - UITableView Delegate and Data Source

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
//        return tempArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userReuseID, for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
//        configuration.text = "\(tempArr[indexPath.row])"
        configuration.text = "\(users[indexPath.row].firstName) \(users[indexPath.row].lastName)"
//        configuration.secondaryText = "This is a placeholder"
        configuration.secondaryText = "\(users[indexPath.row].email)"
        
        cell.contentConfiguration = configuration
        
        return cell
    }
    
}


