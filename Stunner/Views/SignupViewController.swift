import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let firstNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let lastNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let phoneField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupKeyboardObservers()
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    
    // MARK: - Layout Setup
    private func setupLayout() {
        // Add ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Add Container inside ScrollView
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // StackView
        let stack = UIStackView(arrangedSubviews: [
            firstNameField,
            lastNameField,
            phoneField,
            submitButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 150),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
    }

    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let kbFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = kbFrame.height + 20
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    
    // MARK: - Dismiss Keyboard on Tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    // MARK: - Submit Handler
    @objc private func handleSubmit() {
        guard let first = firstNameField.text, !first.isEmpty,
              let last = lastNameField.text, !last.isEmpty,
              let phone = phoneField.text, !phone.isEmpty else {
            showToast("Please fill all fields")
            return
        }
        
        let body: [String: Any] = [
            "firstName": first,
            "lastName": last,
            "phoneNumber": phone
        ]
        
        submitSignup(body: body)
    }

    
    // MARK: - Network Call
    private func submitSignup(body: [String:Any]) {
        guard let url = URL(string: "https://stunner.com/signup") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            DispatchQueue.main.async {
                if let error = error {
                    print("Error:", error)
                    self.showToast("Something went wrong. Try Again !")
                    return
                }
                
                guard let httpRes = response as? HTTPURLResponse,
                      (200...299).contains(httpRes.statusCode) else {
                    self.showToast("Something went wrong. Try Again !")
                    return
                }
                
                // Navigate
                let otpVC = OTPViewController()
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
        }
        task.resume()
    }

    
    // MARK: - Toast
    private func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        toastLabel.frame = CGRect(
            x: 20,
            y: view.frame.height - 120,
            width: view.frame.width - 40,
            height: 50
        )
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.8, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
