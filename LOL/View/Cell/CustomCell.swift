//
//  CustomCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 07/08/24.
//

import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!

    // Closure to handle button tap
    var buttonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        buttonAction?()
    }

    func configure(with image: UIImage?, buttonTitle: String, buttonImage: UIImage?, buttonAction: @escaping () -> Void) {
        imageView.image = image
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(buttonImage, for: .normal)
        self.buttonAction = buttonAction
    }
}
