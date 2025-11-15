//
//  LoginViewModel.swift
//  Stunner
//
//  Created by Garvit Kaushik on 15/11/25.
//

import Foundation

class LoginViewModel {

    // MARK: - Observables
    var onLoginSuccess: (() -> Void)?
    var onLoginFailed: ((String) -> Void)?

    // MARK: - Methods
    func login(email: String, password: String) {
        
        // Validation
        guard !email.isEmpty else {
            onLoginFailed?("Email cannot be empty")
            return
        }
        
        guard !password.isEmpty else {
            onLoginFailed?("Password cannot be empty")
            return
        }

        // Fake API simulation
        if email == "admin@gmail.com" && password == "123456" {
            onLoginSuccess?()
        } else {
            onLoginFailed?("Invalid email or password")
        }
    }
}
