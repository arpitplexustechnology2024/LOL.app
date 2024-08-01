//
//  LaunchViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LottieAnimationView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupLoadingView()
        setupUI()
    }
    
    func setupUI() {
        if traitCollection.userInterfaceStyle == .dark {
            self.backgroundImageView.image = UIImage(named: "LaunchScreenBGDark")
        } else {
            self.backgroundImageView.image = UIImage(named: "LaunchScreenBGLight")
        }
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor(hex: "#FA4957").cgColor,
            UIColor(hex: "#FD7E41").cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupLoadingView() {
        self.loadingView.contentMode = .scaleAspectFit
        self.loadingView.loopMode = .loop
        self.loadingView.play()
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { Time in
            
            self.loadingView.stop()
            self.loadingView.isHidden = true
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignupViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
