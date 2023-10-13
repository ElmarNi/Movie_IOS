//
//  ProfileViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 13.10.23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        DispatchQueue.main.async {
            ApiCaller.shared.getKey(sessionDelegate: self) {result in
                switch result {
                case .success(let data):
                    ApiCaller.shared.authenticate(username: "elmarni", password: "Elmar199@", apiKey: data.request_token, sessionDelegate: self)
                    { result in
                        switch result {
                        case .success(let data):
                            ApiCaller.shared.fetchUserData(apiKey: data.request_token, sessionDelegate: self) { result in
                                switch result {
                                case .success(let data):
                                    print(data)
                                case .failure(_):
                                    self.showError(alertTitle: "Error", message: "Can't get key", actionTitle: "OK")
                                }
                            }
                        case .failure(_):
                            self.showError(alertTitle: "Error", message: "Can't get key", actionTitle: "OK")
                        }
                    }
                case .failure(_):
                    self.showError(alertTitle: "Error", message: "Can't get key", actionTitle: "OK")
                }
            }
        }
    }
    
}
