//
//  SignupViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import Lottie
import TTGSnackbar
import Alamofire

class SignupViewController: UIViewController {
    
    @IBOutlet weak var MaskView: LottieAnimationView!
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var insta_SnapLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var privacyPolicyCheckBox: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var customSwitchContainer: UIView!
    private var customSwitch: CustomSwitch!
    private var isCheckboxChecked: Bool = false
    private var userNameViewModel: UserNameViewModel!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPrivacyPolicyLabel()
        setupCustomSwitch()
        
        let apiService = APIService()
        self.userNameViewModel = UserNameViewModel(apiService: apiService)
        self.userNameViewModel.bindViewModelToController = {
            self.updateErrorLabel()
        }
        self.userNameViewModel.successCallback = {
            self.navigateToProfilePage()
        }
    }
    
    func setupUI() {
        // Lottie Animation
        self.MaskView.contentMode = .scaleAspectFit
        self.MaskView.loopMode = .loop
        self.MaskView.play()
        
        // Activity Indicator Setup
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.color = .white
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.hidesWhenStopped = true
        self.nextButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor)
        ])
        
        // Next button Gradient Color
        self.nextButton.layer.cornerRadius = nextButton.frame.height / 2
        self.nextButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        self.applyGradientToButton(nextButton)
        
        self.errorLabel.isHidden = true
        self.errorLabel.alpha = 0
        // User Name TextField
        self.userNameTextFiled.delegate = self
        self.userNameTextFiled.returnKeyType = .done
        self.userNameTextFiled.layer.borderWidth = 1.5
        self.userNameTextFiled.layer.cornerRadius = 5
        self.userNameTextFiled.layer.borderColor = UIColor.textfieldBoader.cgColor
        self.hideKeyboardTappedAround()
        
        self.privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox"), for: .normal)
        
    }
    
    func applyGradientToButton(_ button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#FA4957").cgColor, UIColor(hex: "#FD7E41").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.bounds.height / 2
        gradientLayer.masksToBounds = true
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.masksToBounds = true
    }
    
    private func setupCustomSwitch() {
        customSwitch = CustomSwitch(frame: CGRect(x: 0, y: 0, width: customSwitchContainer.frame.width, height: customSwitchContainer.frame.height))
        customSwitchContainer.addSubview(customSwitch)
        customSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc func switchValueChanged(sender: CustomSwitch) {
        if sender.isSwitchOn {
            self.insta_SnapLabel.text = "What's your snapchat handle?"
        } else {
            self.insta_SnapLabel.text = "What's your instagram handle?"
        }
    }
    
    @IBAction func privacyPolicyCheckBoxTapped(_ sender: UIButton) {
        isCheckboxChecked.toggle()
            if isCheckboxChecked {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Fill"), for: .normal)
            } else {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox"), for: .normal)
            }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.errorLabel.isHidden = true
        var hasError = false
        
        // Remove "@" from the username if it exists
        let username = userNameTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "@", with: "") ?? ""
        
        if userNameTextFiled.text?.isEmpty ?? true || userNameTextFiled.text == "@" {
            showError(message: "* Username is required")
            hasError = true
        }
        
        if !isCheckboxChecked {
            privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Error"), for: .normal)
            hasError = true
        }
        
        if hasError {
            return
        }
        
        if !isConnectedToInternet() {
            self.showNoInternetSnackbar()
            return
        }
        
        self.startLoading()
        self.userNameViewModel.checkUsername(username: username)
        
        UserDefaults.standard.set(username, forKey: "username")
        print("Username: \(username)")
        
    }
    
    func showError(message: String) {
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 1
        })
    }
    
    func updateErrorLabel() {
        DispatchQueue.main.async {
            self.showError(message: self.userNameViewModel.errorMessage!)
            self.stopLoading()
        }
    }
    
    func navigateToProfilePage() {
        DispatchQueue.main.async {
            self.stopLoading()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func startLoading() {
        self.nextButton.setTitle("", for: .normal)
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
        self.nextButton.setTitle("Next", for: .normal)
    }
    
    func showNoInternetSnackbar() {
        let snackbar = TTGSnackbar(message: "No Internet Connection. Please check your internet connection and try again.", duration: .middle)
        snackbar.show()
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func setupPrivacyPolicyLabel() {
        let text = "By tapping “Continue”, you acknowledge that you have read the Privacy Policy"
        let privacyPolicyRange = (text as NSString).range(of: "Privacy Policy")
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: privacyPolicyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        self.privacyPolicyLabel.addGestureRecognizer(tapGesture)
        self.privacyPolicyLabel.isUserInteractionEnabled = true
        self.privacyPolicyLabel.attributedText = attributedString
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (privacyPolicyLabel.text ?? "") as NSString
        let privacyPolicyRange = text.range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: privacyPolicyLabel, inRange: privacyPolicyRange) {
            self.navigateToPrivacyPolicy()
        }
    }
    
    func navigateToPrivacyPolicy() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PrivacyPolicyViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = "@"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            if currentText == "@" {
                return false
            }
            return true
        }
        if newText.hasPrefix("@") && range.location == 0 && string.isEmpty {
            return false
        }
        return true
    }
}
