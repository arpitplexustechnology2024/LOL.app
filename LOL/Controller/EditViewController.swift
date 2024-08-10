//
//  EditViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var formCollectionView: UICollectionView!
    @IBOutlet weak var formImageView: UIImageView!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectQuestionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let viewModel = EditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI()
        setupGradientBackground()
        setupUI()
        setupBindings()
        viewModel.fetchCardTitles()
    }
    
    private func setupBindings() {
        activityIndicator.startAnimating()
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.formCollectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                print(errorMessage)
            }
        }
    }
    
    func localizeUI() {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        navigationLabel.text = "TabbarItemKey03".localizableString(loc: selectedLanguage)
        descriptionLabel.text = "EditDescriptionKey".localizableString(loc: selectedLanguage)
        nameLabel.text = "EditNameKey".localizableString(loc: selectedLanguage)
        selectQuestionLabel.text = "EditSelectQuesKey".localizableString(loc: selectedLanguage)
        saveCardButton.setTitle("EditSaveCardBtnKey".localizableString(loc: selectedLanguage), for: .normal)
    }
    
    func setupUI() {
        activityIndicator.style = .large
        bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 20
        formImageView.layer.cornerRadius = 12
        formImageView.layer.borderWidth = 1
        formImageView.layer.borderColor = UIColor.white.cgColor
        saveCardButton.layer.cornerRadius = saveCardButton.frame.height / 2
        saveCardButton.frame = CGRect(x: (view.frame.width - 398) / 2, y: view.center.y - 25, width: 398, height: 50)
        saveCardButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        formCollectionView.delegate = self
        formCollectionView.dataSource = self
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
    
    @IBAction func btnSaveCardTapped(_ sender: UIButton) {
        // Implement save functionality if needed
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cardTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormCollectionViewCell", for: indexPath) as! FormCollectionViewCell
        cell.questionNoLabel.text = "\(indexPath.row + 1)"
        cell.questionLabel.text = viewModel.cardTitles[indexPath.row]
        cell.configureGradient(for: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 62)
    }
}
