//
//  SplashScreenViewController.swift
//  Stunner
//
//  Created by Garvit Kaushik on 15/11/25.
//

import UIKit

class SplashScreenViewController: UIViewController {

    // MARK: - Properties

    private let letters = Array("MARKETPLACE")
    private let fontSize: CGFloat = 12
    private var letterSpacing: CGFloat { fontSize * 0.37 }

    private var letterLabels: [UILabel] = []
    var onFinish: (() -> Void)?

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "SplashScreenLogo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let lettersStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLetters()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLetters()
        dismissSplash()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor(named: "stunner") ?? .systemYellow

        view.addSubview(logoImageView)
        view.addSubview(lettersStack)

        NSLayoutConstraint.activate([
            // Center logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 24),

            // Letters 311 points below
            lettersStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lettersStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                              constant: 311)
        ])
    }

    private func setupLetters() {
        letters.forEach { character in
            let label = UILabel()
            label.text = String(character)
            label.font = UIFont(name: "VisbyCF-Medium", size: fontSize)
            label.textColor = .black
            label.alpha = 0
            label.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

            lettersStack.addArrangedSubview(label)
            letterLabels.append(label)

            // Add spacing manually
            lettersStack.setCustomSpacing(letterSpacing, after: label)
        }
    }

    // MARK: - Animations

    private func animateLetters() {
        for (index, label) in letterLabels.enumerated() {
            UIView.animate(
                withDuration: 0.6,
                delay: Double(index) * 0.05,
                options: [.curveEaseInOut],
                animations: {
                    label.alpha = 1
                    label.transform = .identity
                }
            )
        }
    }

    private func dismissSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.4) {
                self.view.alpha = 0
            } completion: { _ in
                self.onFinish?()
            }
        }
    }
}
