//
//  LoginViewController.swift
//  Stunner
//
//  Created by Garvit Kaushik on 15/11/25.
//

import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()

    // MARK: - UI Components

    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
        bindViewModel()
    }

    // MARK: - Layout Setup
    private func setupUI() {
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)

        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Button Action
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""

        viewModel.login(email: email, password: password)
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Success", message: "Login successful!")
            }
        }

        viewModel.onLoginFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error)
            }
        }
    }

    // MARK: - Alert Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
