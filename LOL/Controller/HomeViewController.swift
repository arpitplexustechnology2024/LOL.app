//
//  HomeViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    var cardBGImageArr = ["HomeFirst","HomeSecond","HomeThird","HomeFour","HomeFive","HomeSix","HomeSeven"]
    var cardQuestionArr = ["QuestionsKey01","QuestionsKey02","QuestionsKey03","QuestionsKey04","QuestionsKey05","QuestionsKey06","QuestionsKey07"]
    
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
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardBGImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.cardImageView.image = UIImage(named: cardBGImageArr[indexPath.row])
        cell.configure(with: cardQuestionArr[indexPath.row])
        let defaultAvatarURL = "https://lolcards.link/api/public/images/AvatarDefault.png"
        let avatarURLString = UserDefaults.standard.string(forKey: "avatarURL") ?? defaultAvatarURL
        if let avatarURL = URL(string: avatarURLString) {
            cell.profile_ImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "Photo"))
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26, height: 208)
    }
}

extension HomeViewController: ProfileCollectionViewCellDelegate {
    func didTapProfileChangeButton(in cell: ProfileCollectionViewCell) {
        let titleString = NSAttributedString(string: "Edit profile picture", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        ])
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titleString, forKey: "attributedTitle")
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            // Handle camera action
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            // Handle gallery action
        }
        
        let avatarAction = UIAlertAction(title: "Select Avatar", style: .default) { _ in
            // Handle select avatar action
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(avatarAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

