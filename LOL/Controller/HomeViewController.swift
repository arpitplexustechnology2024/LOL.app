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
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        navigationTitle.text = "TabbarItemKey01".localizableString(loc: selectedLanguage)
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
        cell.configure(with: cardQuestionArr[indexPath.row])
        let defaultAvatarURL = "https://lolcards.link/api/public/images/AvatarDefault.png"
        let avatarURLString = UserDefaults.standard.string(forKey: "avatarURL") ?? defaultAvatarURL
        if let avatarURL = URL(string: avatarURLString) {
            cell.profile_ImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.profile_ChangeButton.tag = indexPath.item
        cell.profile_ChangeButton.addTarget(self, action: #selector(profileChangeButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26, height: 208)
    }
}
