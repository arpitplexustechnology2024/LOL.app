//
//  ProfileCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 20/07/24.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profile_ImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var profile_ChangeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeProfileImageViewCircular()
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
    
    private func makeProfileImageViewCircular() {
        profile_ImageView.layer.cornerRadius = profile_ImageView.frame.size.width / 2
        profile_ImageView.layer.masksToBounds = true
    }
    
    func configure(with cardQuestion: String) {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        questionTextLabel.text = cardQuestion.localizableString(loc: selectedLanguage)
    }
    
    func setProfileImage(_ image: UIImage?) {
        profile_ImageView.image = image
    }
}
