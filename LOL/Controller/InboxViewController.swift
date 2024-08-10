//
//  InboxViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import UIKit

class InboxViewController: UIViewController {
    
    @IBOutlet weak var navigationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI()
    }
    
    func localizeUI() {
        let selectedLanguage = UserDefaults.standard.string(forKey: LanguageSet.languageSelected) ?? "en"
        navigationLabel.text = "TabbarItemKey02".localizableString(loc: selectedLanguage)
    }

}
