//
//  LanguageViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var hindiLanguageButton: UIButton!
    @IBOutlet weak var spanishLanguageButton: UIButton!
    @IBOutlet weak var urduLanguageButton: UIButton!
    @IBOutlet weak var franchLanguageButton: UIButton!
    @IBOutlet weak var blankLanguageButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    
    var selectedLanguage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustImageViewForDevice()
        setupRadioButtons()
        setupUI()
    }
    
    func setupUI() {
        // Done Button Gradient Color
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        doneButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        applyGradientToButton(doneButton)
        doneButton.setTitle("Done", for: .normal)
        
        addShadow(to: englishLanguageButton)
        addShadow(to: hindiLanguageButton)
        addShadow(to: spanishLanguageButton)
        addShadow(to: urduLanguageButton)
        addShadow(to: franchLanguageButton)
        
        // Activity Indicator Setup
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        doneButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor)
        ])
        
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
    
    
    @IBAction func btnLanguageSelectedTapped(_ sender: UIButton) {
        resetButtons()
        sender.isSelected = true
        
        switch sender {
        case englishLanguageButton:
            selectedLanguage = "en"
            
        case hindiLanguageButton:
            selectedLanguage = "hi"
            
        case spanishLanguageButton:
            selectedLanguage = "es"
            
        case urduLanguageButton:
            selectedLanguage = "ur"
            
        case franchLanguageButton:
            selectedLanguage = "fr"
            
        default:
            selectedLanguage = nil
        }
        UserDefaults.standard.set(selectedLanguage, forKey: LanguageSet.languageSelected)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        doneButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()
            self.doneButton.setTitle("Done", for: .normal)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabbarController") as! CustomTabbarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func adjustImageViewForDevice() {
        var width: CGFloat = 131
        var height: CGFloat = 114
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                width = 111
                height = 94
            case 2436, 1792, 2556, 2532:
                width = 141
                height = 124
            case 2796, 2778, 2688:
                width = 151
                height = 134
            default:
                width = 131
                height = 114
            }
        }
        
        englishLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        hindiLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        spanishLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        urduLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        franchLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        blankLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            englishLanguageButton.widthAnchor.constraint(equalToConstant: width),
            englishLanguageButton.heightAnchor.constraint(equalToConstant: height),
            hindiLanguageButton.widthAnchor.constraint(equalToConstant: width),
            hindiLanguageButton.heightAnchor.constraint(equalToConstant: height),
            spanishLanguageButton.widthAnchor.constraint(equalToConstant: width),
            spanishLanguageButton.heightAnchor.constraint(equalToConstant: height),
            urduLanguageButton.widthAnchor.constraint(equalToConstant: width),
            urduLanguageButton.heightAnchor.constraint(equalToConstant: height),
            franchLanguageButton.widthAnchor.constraint(equalToConstant: width),
            franchLanguageButton.heightAnchor.constraint(equalToConstant: height),
            blankLanguageButton.widthAnchor.constraint(equalToConstant: width),
            blankLanguageButton.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}

extension LanguageViewController {
    
    private func setupRadioButtons() {
        setupEnglishButton(englishLanguageButton)
        setupHindiButton(hindiLanguageButton)
        setupSpanishButton(spanishLanguageButton)
        setupUrduButton(urduLanguageButton)
        setupFranchButton(franchLanguageButton)
    }
    
    private func resetButtons() {
        englishLanguageButton.isSelected = false
        hindiLanguageButton.isSelected = false
        spanishLanguageButton.isSelected = false
        urduLanguageButton.isSelected = false
        franchLanguageButton.isSelected = false
    }
    
    private func setupEnglishButton(_ button: UIButton) {
        button.setImage(UIImage(named: "EnglishLanguage"), for: .normal)
        button.setImage(UIImage(named: "EnglishLanguageFill"), for: .selected)
    }
    
    private func setupHindiButton(_ button: UIButton) {
        button.setImage(UIImage(named: "HindiLanguage"), for: .normal)
        button.setImage(UIImage(named: "HindiLanguageFill"), for: .selected)
    }
    
    private func setupSpanishButton(_ button: UIButton) {
        button.setImage(UIImage(named: "SpanishLanguage"), for: .normal)
        button.setImage(UIImage(named: "SpanishLanguageFill"), for: .selected)
    }
    
    private func setupUrduButton(_ button: UIButton) {
        button.setImage(UIImage(named: "UrduLanguage"), for: .normal)
        button.setImage(UIImage(named: "UrduLanguageFill"), for: .selected)
    }
    
    private func setupFranchButton(_ button: UIButton) {
        button.setImage(UIImage(named: "FranchLanguage"), for: .normal)
        button.setImage(UIImage(named: "FranchLanguageFill"), for: .selected)
    }
    
}

func addShadow(to button: UIButton) {
    button.layer.shadowColor = UIColor.darkGray.cgColor
    button.layer.shadowOpacity = 0.5
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 7.4
    button.layer.cornerRadius = 10
    button.layer.masksToBounds = false
}
