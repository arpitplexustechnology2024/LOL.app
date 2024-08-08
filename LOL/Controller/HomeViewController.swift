//
//  HomeViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/08/24.
//

import UIKit
import AVFoundation
import Photos
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    var cardBGImageArr = ["HomeFirst", "HomeSecond", "HomeThird", "HomeFour", "HomeFive", "HomeSix", "HomeSeven"]
    var cardQuestionArr = ["QuestionsKey01", "QuestionsKey02", "QuestionsKey03", "QuestionsKey04", "QuestionsKey05", "QuestionsKey06", "QuestionsKey07"]
    
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
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titleString, forKey: "attributedTitle")
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.btnCameraTapped()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.btnGalleryTapped()
        }
        
        let avatarAction = UIAlertAction(title: "Select Avatar", style: .default) { _ in
            self.btnAvtarTapped()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(avatarAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func btnCameraTapped() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showImagePicker(for: .camera)
                } else {
                    self.showPermissionAlert(for: "camera")
                }
            }
        case .authorized:
            showImagePicker(for: .camera)
        case .restricted, .denied:
            showPermissionAlert(for: "camera")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func btnGalleryTapped() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.showImagePicker(for: .photoLibrary)
                } else {
                    self.showPermissionAlert(for: "photo library")
                }
            }
        case .authorized, .limited:
            showImagePicker(for: .photoLibrary)
        case .restricted, .denied:
            showPermissionAlert(for: "photo library")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            print("\(sourceType) is not available")
        }
    }
    
    func showPermissionAlert(for feature: String) {
        let alert = UIAlertController(title: "Permission Required",
                                      message: "Please grant permission to access your \(feature).",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func btnAvtarTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AvtarBottomViewController") as! AvtarBottomViewController
        
        bottomSheetVC.onAvatarSelected = { [weak self] selectedAvatarURL in
            print("Selected avatar URL: \(selectedAvatarURL)")
            
            if let avatarURL = URL(string: selectedAvatarURL) {
                self?.updateProfileImage(with: avatarURL)
            }
        }
        
        if #available(iOS 15.0, *) {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    func updateProfileImage(with url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] image, data, error, cacheType, finished, url in
            if let image = image {
                UserDefaults.standard.set(image.pngData(), forKey: "profileImage")
                self?.homeCollectionView.reloadData()
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            saveAndDisplayImage(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveAndDisplayImage(image: UIImage) {
        if let imageData = image.pngData() {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
        homeCollectionView.reloadData()
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
        
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"), let image = UIImage(data: imageData) {
            cell.setProfileImage(image)
        } else {
            let defaultAvatarURL = "https://lolcards.link/api/public/images/AvatarDefault.png"
            let avatarURLString = UserDefaults.standard.string(forKey: "avatarURL") ?? defaultAvatarURL
            if let avatarURL = URL(string: avatarURLString) {
                cell.profile_ImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "placeholder"))
            }
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
