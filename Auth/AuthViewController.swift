//
//  ViewController.swift
//  Auth
//
//  Created by Michael Amiro on 01/03/2022.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
    
    let authButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Authenticate", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.authenticate()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 46),
            authButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 40)
        ])
    }
    
    func configureView() {
        authButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authButton)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError? = nil
        let reason = "Authorize with touch ID to enable login using touchID"
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        let alert = UIAlertController(title: "Failed to authenticate", message: "Failed to authenticate", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        feedback.notificationOccurred(.error)
                        return
                    }
                    let vc = UIViewController()
                    vc.view.backgroundColor = .red
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .fullScreen
                    feedback.notificationOccurred(.success)
                    self?.present(navigationController, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Unavailable", message: "Authentication is not allowed on this device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

