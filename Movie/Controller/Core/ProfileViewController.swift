//
//  ProfileViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 13.10.23.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: Properties
    private let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign in", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.isHidden = true
        return btn
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        return spinner
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(signInButton)
        view.addSubview(spinner)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        setupUI()
        
        let userId = UserDefaults.standard.value(forKey: "UserId")
        signInButton.isHidden = (userId != nil)
        tableView.isHidden = (userId == nil)

    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        tableView.snp.makeConstraints { make in
            make.left.top.width.height.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: handle tapping main sign in button
    @objc func signInButtonTapped() {
        let alert = UIAlertController(title: "Sign In", message: "", preferredStyle: .alert)
        
        alert.addTextField{ textField in
            textField.placeholder = "Username"
        }
        
        alert.addTextField{ textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
            self.getUsersData(alert: alert)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alert, animated: true)
    }
    
    //MARK: get user data from api, show error or success cases, configure view for successfully signed in or not
    private func getUsersData(alert: UIAlertController) {
        self.signInButton.isHidden = true
        self.spinner.startAnimating()
        self.spinner.isHidden = false
        
        if let userNameField = alert.textFields?[0], let userName = userNameField.text,
           let passwordField = alert.textFields?[1], let password = passwordField.text
           
        {
            DispatchQueue.main.async {
                ApiCaller.shared.getKey(sessionDelegate: self) {result in
                    switch result {
                    case .success(let data):
                        ApiCaller.shared.authenticate(username: userName, password: password, apiKey: data.request_token, sessionDelegate: self)
                        { result in
                            switch result {
                            case .success(let data):
                                ApiCaller.shared.fetchUserData(apiKey: data.request_token, sessionDelegate: self) { result in
                                    switch result {
                                    case .success(_):
                                        Haptics.shared.triggerNotificationFeedback(type: .success)
                                        self.configureSpinnerAndSignInButton(success: true)
                                        self.tableView.reloadData()
                                    case .failure(_):
                                        Haptics.shared.triggerNotificationFeedback(type: .error)
                                        self.showMessage(alertTitle: "Error", message: "Username or Password are wrong", actionTitle: "OK")
                                        self.configureSpinnerAndSignInButton(success: false)
                                    }
                                }
                            case .failure(_):
                                Haptics.shared.triggerNotificationFeedback(type: .error)
                                self.showMessage(alertTitle: "Error", message: "Username or Password are wrong", actionTitle: "OK")
                                self.configureSpinnerAndSignInButton(success: false)
                            }
                        }
                    case .failure(_):
                        Haptics.shared.triggerNotificationFeedback(type: .error)
                        self.showMessage(alertTitle: "Error", message: "Username or Password are wrong", actionTitle: "OK")
                        self.configureSpinnerAndSignInButton(success: false)
                    }
                }
            }
        }
        else {
            Haptics.shared.triggerNotificationFeedback(type: .error)
            self.showMessage(alertTitle: "Error", message: "Username or Password are wrong", actionTitle: "OK")
            self.configureSpinnerAndSignInButton(success: false)
        }
    }
    
    //MARK: configure spinner and sign-in button based on success flag
    private func configureSpinnerAndSignInButton(success: Bool) {
        self.signInButton.isHidden = success
        self.tableView.isHidden = !success
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
}

//MARK: table view delegate and data source
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Username: \(UserDefaults.standard.value(forKey: "UserName") ?? "")"
            cell.textLabel?.textColor = .label
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        case 1:
            cell.textLabel?.text = "Favourite movies"
            cell.textLabel?.textColor = .label
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        case 2:
            cell.textLabel?.text = "Log out"
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            guard let userId = UserDefaults.standard.value(forKey: "UserId") as? Int else { return }
            let moviesVC = MoviesViewController(userId: userId, isFromProfile: true)
            navigationController?.pushViewController(moviesVC, animated: true)
        case 2:
            let alert = UIAlertController(title: "Log out", message: "Are you sure for log out ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in
                Haptics.shared.triggerNotificationFeedback(type: .success)
                ApiCaller.shared.logOut()
                self.configureSpinnerAndSignInButton(success: false)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            present(alert, animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
