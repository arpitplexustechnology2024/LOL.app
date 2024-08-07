//
//  ProfileViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import TTGSnackbar
import SDWebImage

@available(iOS 15.0, *)
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
    }
    
    func setupUI() {
        // Avtar Image View
        if let url = URL(string: "https://lolcards.link/api/public/images/AvatarDefault.png") {
            AvtarImageview.sd_setImage(with: url)
        }
        self.AvtarImageview.layer.cornerRadius = AvtarImageview.frame.height / 2
        self.AvtarImageview.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAvtarTapped(_:)))
        AvtarImageview.addGestureRecognizer(tapGestureRecognizer)
        
        // Let's Go button Gradient Color
        self.letsgoButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        self.letsgoButton.layer.cornerRadius = letsgoButton.frame.height / 2
        self.applyGradientToButton(letsgoButton)
        
        self.errorLabel.isHidden = true
        self.errorLabel.alpha = 0
        // Name TextField
        self.nameTextfiled.returnKeyType = .done
        self.nameTextfiled.delegate = self
        self.hideKeyboardTappedAround()
        if traitCollection.userInterfaceStyle == .dark {
            self.nameTextfiled.layer.borderWidth = 1.5
            self.nameTextfiled.layer.cornerRadius = 5
            self.nameTextfiled.layer.borderColor = UIColor.white.cgColor
            self.backButton.setImage(UIImage(named: "BackIcon_Dark"), for: .normal)
        } else {
            self.nameTextfiled.layer.borderWidth = 1.5
            self.nameTextfiled.layer.cornerRadius = 5
            self.nameTextfiled.layer.borderColor = UIColor.black.cgColor
            self.backButton.setImage(UIImage(named: "BackIcon_Light"), for: .normal)
        }
    }
    
    @objc func selectAvtarTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AvtarBottomViewController") as! AvtarBottomViewController
        
        bottomSheetVC.onAvatarSelected = { [weak self] avatarURL in
            // Save the URL to UserDefaults
            UserDefaults.standard.set(avatarURL, forKey: "avatarURL")
            print("AvatarURL : \(avatarURL)")
    
            self?.AvtarImageview.sd_setImage(with: URL(string: avatarURL), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(bottomSheetVC, animated: true, completion: nil)
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
        self.errorLabel.isHidden = true
        guard let name = nameTextfiled.text, !name.isEmpty else {
            showError(message: "* Name is required")
            return
        }
        
        UserDefaults.standard.set(name, forKey: "name")
        print("Name : \(name)")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LanguageViewController") as! LanguageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String) {
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 1
        })
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
