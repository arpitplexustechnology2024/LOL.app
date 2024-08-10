//
//  ShareViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var copyLinkview: UIView!
    @IBOutlet weak var shareLinkView: UIView!
    @IBOutlet weak var copyLinkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var copyLinkLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustForDevice()
        localizeUI()
        setupUI()
    }
    
    func setupUI() {
        copyLinkview.layer.cornerRadius = 27
        shareLinkView.layer.cornerRadius = 27
        self.shareButton.layer.cornerRadius = self.shareButton.frame.height / 2
        shareButton.frame = CGRect(x: (view.frame.width - 386) / 2, y: view.center.y - 20, width: 386, height: 50)
        shareButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        self.copyLinkButton.layer.cornerRadius = self.copyLinkButton.frame.height / 2
        copyLinkButton.layer.borderWidth = 3
        copyLinkButton.layer.borderColor = UIColor.boadercolor.cgColor
        
        if let userLink = UserDefaults.standard.string(forKey: "isUserLink") {
            linkLabel.text = userLink
        }
    }
    
    func localizeUI() {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        copyLinkLabel.text = "CopyLabelKey".localizableString(loc: selectedLanguage)
        shareLabel.text = "ShareLabelKey".localizableString(loc: selectedLanguage)
        shareButton.setTitle("ShareBtnKey".localizableString(loc: selectedLanguage), for: .normal)
        copyLinkButton.setTitle("CopyBtnKey".localizableString(loc: selectedLanguage), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
    }
    
    func adjustForDevice() {
        var height: CGFloat = 190
        var fontSize: CGFloat = 16
        var fontTitleSize: CGFloat = 22
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                fontSize = 16
                fontTitleSize = 19
                height = 140
            case 2436, 2688, 1792, 2556, 2796, 2778, 2532:
                fontSize = 20
                height = 180
            default:
                fontSize = 16
                height = 170
            }
            
            linkLabel.font = UIFont(name: "Lato-Bold", size: fontSize)
            copyLinkLabel.font = UIFont(name: "Lato-ExtraBold", size: fontTitleSize)
            shareLabel.font = UIFont(name: "Lato-ExtraBold", size: fontTitleSize)
        }
        
        copyLinkview.translatesAutoresizingMaskIntoConstraints = false
        shareLinkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyLinkview.heightAnchor.constraint(equalToConstant: height),
            shareLinkView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        // Copy the link to the clipboard
        if let link = linkLabel.text {
            UIPasteboard.general.string = link
            
            // Create and present the custom alert view controller
            let customAlertVC = CustomAlertViewController()
            customAlertVC.modalPresentationStyle = .overFullScreen
            customAlertVC.modalTransitionStyle = .crossDissolve
            customAlertVC.message = "🔗 Link Copied!"
            customAlertVC.link = link
            customAlertVC.image = UIImage(named: "CopyLink")
            
            self.present(customAlertVC, animated: true) {
                // Dismiss the alert after 1.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    customAlertVC.animateDismissal {
                        customAlertVC.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        // Implement share functionality here
    }
}
