//
//  PrivacyPolicyViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Done Button Gradient Color
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        applyGradientToButton(doneButton)
        if traitCollection.userInterfaceStyle == .dark {
            backButton.setImage(UIImage(named: "BackIcon_Dark"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "BackIcon_Light"), for: .normal)
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
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}