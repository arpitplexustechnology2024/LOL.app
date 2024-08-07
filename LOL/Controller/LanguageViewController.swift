//
//  LanguageViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var englishLanguage: UIView!
    @IBOutlet weak var hindiLanguage: UIView!
    @IBOutlet weak var spanishLanguage: UIView!
    @IBOutlet weak var urduLanguage: UIView!
    @IBOutlet weak var franchLanguage: UIView!
    @IBOutlet weak var blankLanguage: UIView!
    
    @IBOutlet var languageHeightConstraints: [NSLayoutConstraint]!
    @IBOutlet var languageWidthConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var languageLogo: [UILabel]!
    @IBOutlet var languageText: [UILabel]!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    
    var selectedLanguage: String?
    private let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustImageViewForDevice()
        setupLanguageViews()
        setupUI()
    }
    
    func setupUI() {
        // Other UI setup
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        doneButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        applyGradientToButton(doneButton)
        doneButton.setTitle("Done", for: .normal)
        
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
        
        let backButtonImageName = traitCollection.userInterfaceStyle == .dark ? "BackIcon_Dark" : "BackIcon_Light"
        backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
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
    
    @objc func viewLanguageSelectedTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        resetViews()
        addShadow(to: selectedView)
        
        let views = [englishLanguage, hindiLanguage, spanishLanguage, urduLanguage, franchLanguage]
        for view in views {
            if view != selectedView {
                view?.layer.shadowOpacity = 0
            }
        }
        
        switch selectedView {
        case englishLanguage:
            selectedLanguage = "\(1)"
        case hindiLanguage:
            selectedLanguage = "\(2)"
        case spanishLanguage:
            selectedLanguage = "\(3)"
        case urduLanguage:
            selectedLanguage = "\(4)"
        case franchLanguage:
            selectedLanguage = "\(5)"
        default:
            selectedLanguage = "\(1)"
        }
        updateBorders(for: selectedView)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        doneButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        let name = UserDefaults.standard.string(forKey: "name")
        let username = UserDefaults.standard.string(forKey: "username")
        let defaultAvatar = "https://lolcards.link/api/public/images/AvatarDefault.png"
        let avatar = UserDefaults.standard.string(forKey: "avatarURL") ?? defaultAvatar
        
        viewModel.registerUser(name: name!, avatar: avatar, username: username!, language: selectedLanguage ?? "\(1)") { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.doneButton.setTitle("Done", for: .normal)
                
                switch result {
                case .success(let profile):
                    print("Successfully registered: \(profile)")
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabbarController") as! CustomTabbarController
                    self.navigationController?.pushViewController(vc, animated: true)

                case .failure(let error):
                    print("Registration error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func adjustImageViewForDevice() {
        let screenHeight = UIScreen.main.nativeBounds.height
        if UIDevice.current.userInterfaceIdiom == .phone {
            let height: CGFloat
            let width: CGFloat
            let logoSize: CGFloat
            let textSize: CGFloat
            
            switch screenHeight {
            case 1136, 1334, 1920, 2208:
                height = 101
                width = 111
                logoSize = 50
                textSize = 14
            case 2436, 1792, 2556, 2532:
                height = 131
                width = 141
                logoSize = 65
                textSize = 17
            case 2796, 2778, 2688:
                height = 141
                width = 151
                logoSize = 70
                textSize = 20
            default:
                height = 121
                width = 131
                logoSize = 60
                textSize = 15
            }
            
            languageText.forEach { label in
                label.font = UIFont(name: "Lato-SemiBold", size: textSize)
            }
            languageLogo.forEach { label in
                label.font = UIFont(name: "Lato-SemiBold", size: logoSize)
            }
            setConstraints(height: height, width: width)
        }
    }
    
    func setConstraints(height: CGFloat, width: CGFloat) {
        languageHeightConstraints.forEach { $0.constant = height }
        languageWidthConstraints.forEach { $0.constant = width }
    }
}

extension LanguageViewController {
    
    private func setupLanguageViews() {
        let views = [englishLanguage, hindiLanguage, spanishLanguage, urduLanguage, franchLanguage]
        for view in views {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewLanguageSelectedTapped(_:)))
            view?.addGestureRecognizer(tapGesture)
            setCornerRadiusAndBorder(for: view)
        }
    }
    
    private func resetViews() {
        let views = [englishLanguage, hindiLanguage, spanishLanguage, urduLanguage, franchLanguage]
        views.forEach { setCornerRadiusAndBorder(for: $0, borderWidth: 0) }
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 7.4
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
    }
    
    private func updateBorders(for selectedView: UIView) {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let borderColor: UIColor = isDarkMode ? .white : .black
        let views = [englishLanguage, hindiLanguage, spanishLanguage, urduLanguage, franchLanguage]
        for view in views {
            if view == selectedView {
                view?.layer.borderWidth = 3
                view?.layer.borderColor = borderColor.cgColor
            } else {
                view?.layer.borderWidth = 0
                view?.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    private func setCornerRadiusAndBorder(for view: UIView?, borderWidth: CGFloat = 0) {
        view?.layer.cornerRadius = 20
        view?.layer.borderWidth = borderWidth
    }
}
