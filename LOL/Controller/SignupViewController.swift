//
//  SignupViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import Lottie

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPrivacyPolicyLabel()
        setupCustomSwitch()
    }
    
    func setupUI() {
        // Lottie Animation
        MaskView.contentMode = .scaleAspectFit
        MaskView.loopMode = .loop
        MaskView.play()
        
        // Next button Gradient Color
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        applyGradientToButton(nextButton)
        
        errorLabel.isHidden = true
        // User Name TextField
        self.userNameTextFiled.delegate = self
        self.userNameTextFiled.returnKeyType = .done
        self.hideKeyboardTappedAround()
        if traitCollection.userInterfaceStyle == .dark {
            userNameTextFiled.layer.borderWidth = 1.5
            userNameTextFiled.layer.cornerRadius = 5
            userNameTextFiled.layer.borderColor = UIColor.white.cgColor
            privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Dark"), for: .normal)
        } else {
            userNameTextFiled.layer.borderWidth = 1.5
            userNameTextFiled.layer.cornerRadius = 5
            userNameTextFiled.layer.borderColor = UIColor.black.cgColor
            privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Light"), for: .normal)
        }
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
        if traitCollection.userInterfaceStyle == .dark {
            if isCheckboxChecked {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Fill"), for: .normal)
            } else {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Dark"), for: .normal)
            }
        } else {
            if isCheckboxChecked {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Fill"), for: .normal)
            } else {
                privacyPolicyCheckBox.setImage(UIImage(named: "Checkbox.Light"), for: .normal)
            }
        }
        privacyPolicyCheckBox.layer.borderColor = UIColor.clear.cgColor
        privacyPolicyCheckBox.layer.borderWidth = 0
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        errorLabel.isHidden = true
        privacyPolicyCheckBox.layer.borderColor = UIColor.clear.cgColor
        privacyPolicyCheckBox.layer.borderWidth = 0
        var hasError = false
        
        if userNameTextFiled.text?.isEmpty ?? true || userNameTextFiled.text == "@" {
            errorLabel.text = "* Username is required"
            errorLabel.isHidden = false
            hasError = true
        }
        
        if !isCheckboxChecked {
            privacyPolicyCheckBox.layer.borderColor = UIColor.red.cgColor
            privacyPolicyCheckBox.layer.borderWidth = 1
            privacyPolicyCheckBox.layer.cornerRadius = 2
            hasError = true
        }
        
        if hasError {
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setupPrivacyPolicyLabel() {
        let text = "By tapping “Continue”, you acknowledge that you have read the Privacy Policy"
        let privacyPolicyRange = (text as NSString).range(of: "Privacy Policy")
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: privacyPolicyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        privacyPolicyLabel.addGestureRecognizer(tapGesture)
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.attributedText = attributedString
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (privacyPolicyLabel.text ?? "") as NSString
        let privacyPolicyRange = text.range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: privacyPolicyLabel, inRange: privacyPolicyRange) {
            navigateToPrivacyPolicy()
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
