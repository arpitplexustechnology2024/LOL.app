//
//  CardQuestionViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/07/24.
//

import UIKit

class CardQuestionViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var editQuestionButton: UIButton!
    @IBOutlet weak var cardQuestionStackView: UIStackView!
    @IBOutlet weak var question_OneView: UIView!
    @IBOutlet weak var question_SecondView: UIView!
    @IBOutlet weak var question_ThirdView: UIView!
    @IBOutlet weak var question_FourView: UIView!
    @IBOutlet weak var question_FiveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupQuestionUI()
        setupUI()
    }
    
    func setupUI() {
        bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 20
        cardQuestionStackView.spacing = getSpacingForDevice()
        editQuestionButton.layer.cornerRadius = editQuestionButton.frame.height / 2
        editQuestionButton.frame = CGRect(x: (view.frame.width - 374) / 2, y: view.center.y - 25, width: 374, height: 50)
        applyGradientToButton(editQuestionButton)
        
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
        shareButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        applyGradientToButton(shareButton)
        
        if traitCollection.userInterfaceStyle == .dark {
            backButton.setImage(UIImage(named: "BackIcon_Dark"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "BackIcon_Light"), for: .normal)
        }
    }
    
    func setupQuestionUI() {
        // Question setup
        question_OneView.layer.cornerRadius = 10
        question_SecondView.layer.cornerRadius = 10
        question_ThirdView.layer.cornerRadius = 10
        question_FourView.layer.cornerRadius = 10
        question_FiveView.layer.cornerRadius = 10
        question_OneView.layer.masksToBounds = true
        question_SecondView.layer.masksToBounds = true
        question_ThirdView.layer.masksToBounds = true
        question_FourView.layer.masksToBounds = true
        question_FiveView.layer.masksToBounds = true
        question_OneView.applyGradient(colors: [UIColor(hex: "#F9A170").cgColor, UIColor(hex: "#FF7195").cgColor])
        question_SecondView.applyGradient(colors: [UIColor(hex: "#D184FF").cgColor, UIColor(hex: "#9A55FF").cgColor])
        question_ThirdView.applyGradient(colors: [UIColor(hex: "#61A7FF").cgColor, UIColor(hex: "#1E78E5").cgColor])
        question_FourView.applyGradient(colors: [UIColor(hex: "#7AD8D0").cgColor, UIColor(hex: "#04CEAD").cgColor])
        question_FiveView.applyGradient(colors: [UIColor(hex: "#026178").cgColor, UIColor(hex: "#01B7E3").cgColor])
    }
    
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(hex: "#623EAD").cgColor,
            UIColor(hex: "#352858").cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        gradientLayer.masksToBounds = true
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
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
    
    @IBAction func btnEditQuestionTapped(_ sender: UIButton) {
        
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
            if let editViewcontroller = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "EditViewController" }) {
                tabBarController.selectedViewController = editViewcontroller
                let navigationController = UINavigationController(rootViewController: tabBarController)
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSpacingForDevice() -> CGFloat {
        var spacing: CGFloat = 15
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208:
                spacing = 10
                
            case 2436, 2688, 1792, 2556, 2532:
                spacing = 16
                
            case 2796, 2778:
                spacing = 25
                
            default:
                spacing = 16
            }
        }
        return spacing
    }
}

private extension UIView {
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
