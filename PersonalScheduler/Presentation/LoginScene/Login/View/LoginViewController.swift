//
//  LoginViewController.swift
//  PersonalScheduler
//
//  Created by 이원빈 on 2023/01/09.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(with viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            //
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    private func setupInitialView() {
        view = loginView
    }
    
    private func setupButton() {
        loginView.loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        
        loginView.signInButton.addTarget(
            self,
            action: #selector(signInButtonTapped),
            for: .touchUpInside
        )
        
        loginView.kakaoLogoImageButton.addTarget(
            self,
            action: #selector(kakaoButtonTapped),
            for: .touchUpInside
        )
        
        loginView.facebookLogoImageButton.addTarget(
            self,
            action: #selector(facebookButtonTapped),
            for: .touchUpInside
        )
        
        loginView.appleLogoImageButton.addTarget(
            self,
            action: #selector(appleButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func loginButtonTapped() {
        guard let loginInfo = loginView.retrieveLoginInfo() else {
            return
        }
        do {
            try loginInfo.validate()
        } catch let error as LoginError {
            DefaultAlertBuilder(
                title: "경고",
                message: error.description,
                preferredStyle: .alert
            ).setButton(name: "예", style: .default)
                .showAlert(on: self)
        } catch {
            print(String(describing: error))
        }
        viewModel.loginButtonTapped(loginInfo)
    }
    
    @objc private func signInButtonTapped() {
        viewModel.signinButtonTapped()
    }
    
    @objc private func kakaoButtonTapped() {
        viewModel.kakaoLogoButtonTapped()
    }
    
    @objc private func facebookButtonTapped() {
        viewModel.facebookLogoButtonTapped()
    }
    
    @objc private func appleButtonTapped() {
        viewModel.appleLogoButtonTapped()
    }
}
