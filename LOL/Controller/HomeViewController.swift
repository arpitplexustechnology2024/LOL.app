//
//  HomeViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    var cardBGImageArr = ["HomeFirst","HomeSecond","HomeThird","HomeFour","HomeFive","HomeSix","HomeSeven"]
    var cardQuestionArr = ["Do you know me better ?","How well do you know myself ?","Want to discover about me ?","How well do you know myself ?","How well do you know myself ?","How well do you know myself ?","Want to discover about me ?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        
        localizeUI()
    }
    
    func localizeUI() {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected)
        switch selectedLanguage {
        case "en":
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "en")
        case "hi":
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "hi")
        case "es":
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "es")
        case "ur":
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "ur")
        case "fr":
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "fr")
        default:
            navigationTitle.text = "TabbarItemKey01".localizableString(loc: "en")
        }
    }
    
    @objc func profileChangeButton(_ sender: UIButton) {
        let titleString = NSAttributedString(string: "Edit profile picture", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        ])
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.setValue(titleString, forKey: "attributedTitle")
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            
        }
        
        let avatarAction = UIAlertAction(title: "Select Avatar", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(avatarAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardBGImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.cardImageView.image = UIImage(named: cardBGImageArr[indexPath.row])
        cell.questionTextLabel.text = cardQuestionArr[indexPath.row]
        cell.profile_ChangeButton.tag = indexPath.item
        cell.profile_ChangeButton.addTarget(self, action: #selector(profileChangeButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CardQuestionViewController") as! CardQuestionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26, height: 208)
    }
}
