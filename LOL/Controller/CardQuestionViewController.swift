//
//  CardQuestionViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 08/08/24.
//

import UIKit

class CardQuestionViewController: UIViewController {
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var QuestionsTitleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var editQuestionButton: UIButton!
    @IBOutlet weak var cardQuestionCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: CardQuestionViewModel!
    
    init(viewModel: CardQuestionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = CardQuestionViewModel(apiService: CardQuestionApiService.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        localizeUI()
        setupBindings()
        viewModel.fetchCardTitles()
    }
    
    func localizeUI() {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        navigationTitle.text = "CardQuesKey".localizableString(loc: selectedLanguage)
        descriptionLabel.text = "CardDescriptionKey".localizableString(loc: selectedLanguage)
        QuestionsTitleLabel.text = "FiveQuesKey".localizableString(loc: selectedLanguage)
        shareButton.setTitle("ShareBtnKey".localizableString(loc: selectedLanguage), for: .normal)
        editQuestionButton.setTitle("EditQuesBtnKey".localizableString(loc: selectedLanguage), for: .normal)
    }
    
    func setupUI() {
        activityIndicator.style = .large
        bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 20
        cardQuestionCollectionView.delegate = self
        cardQuestionCollectionView.dataSource = self
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
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#623EAD").cgColor, UIColor(hex: "#352858").cgColor]
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
    
    func setupBindings() {
        activityIndicator.startAnimating()
        viewModel.reloadData = { [weak self] in
            self?.cardQuestionCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
        viewModel.showError = { errorMessage in
            print("Error: \(errorMessage)")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func btnEditQuestionTapped(_ sender: UIButton) {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
            if let editViewcontroller = tabBarController.viewControllers?.first(where: { $0.restorationIdentifier == "EditViewController" }) {
                tabBarController.selectedViewController = editViewcontroller
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
            if #available(iOS 15.0, *) {
                if let sheet = bottomSheetVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
            }
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CardQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardQuestionCollectionViewCell", for: indexPath) as! CardQuestionCollectionViewCell
        cell.configureGradient(for: indexPath.item)
        cell.questionNoLabel.text = "\(indexPath.row + 1)"
        cell.questionLabel.text = viewModel.cardTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 62)
    }
}
