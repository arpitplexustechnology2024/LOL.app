//
//  ProfileViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var AvtarImageview: UIImageView!
    @IBOutlet weak var nameTextfiled: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var letsgoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let username = UserDefaults.standard.string(forKey: "username") {
            Label.text = "Select \(username) avatar"
        }
    }
    
    func setupUI() {
        // Avtar Image View
        AvtarImageview.layer.cornerRadius = AvtarImageview.frame.height / 2
        AvtarImageview.layer.borderWidth = 10
        AvtarImageview.layer.borderColor = UIColor.customWhite.cgColor
        AvtarImageview.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAvtarTapped(_:)))
        AvtarImageview.addGestureRecognizer(tapGestureRecognizer)
        
        // Let's Go button Gradient Color
        letsgoButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        letsgoButton.layer.cornerRadius = letsgoButton.frame.height / 2
        applyGradientToButton(letsgoButton)
        
        errorLabel.isHidden = true
        // Name TextField
        self.nameTextfiled.returnKeyType = .done
        self.nameTextfiled.delegate = self
        self.hideKeyboardTappedAround()
        if traitCollection.userInterfaceStyle == .dark {
            nameTextfiled.layer.borderWidth = 1.5
            nameTextfiled.layer.cornerRadius = 5
            nameTextfiled.layer.borderColor = UIColor.white.cgColor
            backButton.setImage(UIImage(named: "BackIcon_Dark"), for: .normal)
        } else {
            nameTextfiled.layer.borderWidth = 1.5
            nameTextfiled.layer.cornerRadius = 5
            nameTextfiled.layer.borderColor = UIColor.black.cgColor
            backButton.setImage(UIImage(named: "BackIcon_Light"), for: .normal)
        }
    }
    
    @objc func selectAvtarTapped(_ sender: UITapGestureRecognizer){
        print("Avtar Tapped")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func btnLetsgoTapped(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let text = nameTextfiled.text, !text.isEmpty else {
            errorLabel.text = "* Name is required"
            errorLabel.isHidden = false
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LanguageViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
