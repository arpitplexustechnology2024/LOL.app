//
//  ProfileCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 20/07/24.
//

import UIKit

protocol ProfileCollectionViewCellDelegate: AnyObject {
    func didTapProfileChangeButton(in cell: ProfileCollectionViewCell)
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profile_ImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var profile_ChangeButton: UIButton!
    
    weak var delegate: ProfileCollectionViewCellDelegate?
    
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
        // Set the corner radius
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        
        // Set the shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
    
    private func makeProfileImageViewCircular() {
        profile_ImageView.layer.cornerRadius = profile_ImageView.frame.size.width / 2
        profile_ImageView.layer.masksToBounds = true
        
        profile_ChangeButton.setImage(UIImage(named: "EditPhoto"), for: .normal)
        profile_ChangeButton.addTarget(self, action: #selector(profileChangeButtonTapped), for: .touchUpInside)
    }
    
    @objc func profileChangeButtonTapped() {
        delegate?.didTapProfileChangeButton(in: self)
    }
    
    func configure(with cardQuestion: String) {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        questionTextLabel.text = cardQuestion.localizableString(loc: selectedLanguage)
    }
}
