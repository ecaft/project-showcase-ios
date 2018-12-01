//
//  LoginViewController.swift
//  
//
//  Created by Claire on 11/30/18.
//

import UIKit

class LoginViewController: UIViewController {
    
    var lockImageView: UIImageView!
    var employerOnlyLabel: UILabel!
    var emailLabel: UILabel!
    var passWordLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var correctPassWord: String = "ECAFT"

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor.ecaftRed
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.ecaftWhite]
        self.navigationItem.title = "Project Showcase Login"
        self.view.backgroundColor = UIColor.backgroundGray

        lockImageView = UIImageView()
        lockImageView.image = UIImage(named: "loginLock")
        lockImageView.translatesAutoresizingMaskIntoConstraints = false

        
        employerOnlyLabel = UILabel()
        employerOnlyLabel.text = "Employers Only"
        employerOnlyLabel.textColor = UIColor.ecaftBlack
        employerOnlyLabel.font = UIFont.systemFont(ofSize: 18)
        employerOnlyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel = UILabel()
        emailLabel.text = "Email: "
        emailLabel.textColor = UIColor.ecaftRed
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passWordLabel = UILabel()
        passWordLabel.text = "Password: "
        passWordLabel.textColor = UIColor.ecaftRed
        passWordLabel.font = UIFont.systemFont(ofSize: 18)
        passWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Please enter your email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isUserInteractionEnabled = true
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Please enter your password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isUserInteractionEnabled = true

        
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.ecaftDarkRed, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(lockImageView)
        view.addSubview(employerOnlyLabel)
        view.addSubview(emailLabel)
        view.addSubview(passWordLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            lockImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            lockImageView.bottomAnchor.constraint(equalTo: employerOnlyLabel.topAnchor, constant: -16)
            ])
        
        NSLayoutConstraint.activate([
            employerOnlyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            employerOnlyLabel.centerYAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -32)
            ])
        
        NSLayoutConstraint.activate([
            emailLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48)
            ])
        
        NSLayoutConstraint.activate([
            passWordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passWordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48)
            ])
        
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 32),
            emailTextField.widthAnchor.constraint(equalToConstant: 256)
            ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerYAnchor.constraint(equalTo: passWordLabel.centerYAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 256)
            ])
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: passWordLabel.bottomAnchor, constant: 32)
            ])
        
        // Do any additional setup after loading the view.
        
        
    }
    
    @objc func loginButtonPressed() {
        if let passWord = passwordTextField.text {
            print("password: " + passWord)
            if (passWord == correctPassWord) {
                print("here")
                let tabBarVC = TabBarViewController()
                tabBarVC.tabBar.barTintColor = UIColor.ecaftGray
                present(tabBarVC, animated: true, completion: nil)
                //navigationController?.pushViewController(tabBarVC, animated: true)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
