//
//  FormCollectionViewCell.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

class FormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var editPremiumButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    
    func configureGradient(for index: Int) {
           let colors: [[CGColor]] = [
            [UIColor(hex: "#F9A170").cgColor, UIColor(hex: "#FF7195").cgColor],
            [UIColor(hex: "#D184FF").cgColor, UIColor(hex: "#9A55FF").cgColor],
            [UIColor(hex: "#9A55FF").cgColor, UIColor(hex: "#1E78E5").cgColor],
            [UIColor(hex: "#7AD8D0").cgColor, UIColor(hex: "#04CEAD").cgColor],
            [UIColor(hex: "#026178").cgColor, UIColor(hex: "#01B7E3").cgColor],
            [UIColor(hex: "#A7003C").cgColor, UIColor(hex: "#1A0E32").cgColor, UIColor(hex: "#5738B6").cgColor, UIColor(hex: "#D01DDF").cgColor],
            [UIColor(hex: "#804192").cgColor, UIColor(hex: "#CE2840").cgColor],
            [UIColor(hex: "#FE99C6").cgColor, UIColor(hex: "#FECDC7").cgColor],
            [UIColor(hex: "#F15237").cgColor, UIColor(hex: "#FAAA3F").cgColor],
            [UIColor(hex: "#F13784").cgColor, UIColor(hex: "#FD74B1").cgColor],
           ]
           
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = self.bounds
           gradientLayer.colors = colors[index % colors.count]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           
           if let oldLayer = self.contentView.layer.sublayers?.first as? CAGradientLayer {
               oldLayer.removeFromSuperlayer()
           }
           
           self.contentView.layer.insertSublayer(gradientLayer, at: 0)
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = self.contentView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
}
