//
//  MyCollectionViewController.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 07/08/24.
//

import UIKit
import Photos
import AVFoundation

class MyCollectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedCell: CustomCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        // Load previously saved image if available
        loadSavedImage()
    }
}

// MARK: - UICollectionViewDataSource
extension MyCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let image = UIImage(named: "HomeThird")
        let buttonImage = UIImage(named: "EditPhoto")
        let buttonTitle = indexPath.item % 2 == 0 ? "Create" : "Edit"
        cell.configure(with: image, buttonTitle: buttonTitle, buttonImage: buttonImage) {
            self.selectedCell = cell
            self.showActionSheet()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MyCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: - Show Action Sheet
extension MyCollectionViewController {
    private func showActionSheet() {
        let titleString = NSAttributedString(string: "Edit profile picture", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        ])
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titleString, forKey: "attributedTitle")
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.checkCameraPermissionAndPresent()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.checkPhotoLibraryPermission { granted in
                if granted {
                    self.showImagePickerController(sourceType: .photoLibrary)
                } else {
                    self.showSettingsAlert()
                }
            }
        }
        
        let avatarAction = UIAlertAction(title: "Select Avatar", style: .default) { _ in
            // Handle select avatar action if needed
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(avatarAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

    private func checkCameraPermissionAndPresent() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentImagePicker(sourceType: .camera)
                    }
                }
            }
        case .denied, .restricted:
            showAlertForDeniedAccess()
        @unknown default:
            fatalError("Unexpected authorization status")
        }
    }

    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        case .limited:
            completion(true) // Assuming user has limited access but still has some permissions
        @unknown default:
            completion(false)
        }
    }

    private func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("\(sourceType) not available")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        showImagePickerController(sourceType: sourceType)
    }

    private func showAlertForDeniedAccess() {
        let alert = UIAlertController(title: "Access Denied", message: "Please enable access to the camera or photo library in your settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showSettingsAlert() {
        let alertController = UIAlertController(
            title: "Photo Library Access Needed",
            message: "Please allow access to the photo library in settings to select a photo.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { success in
                    print("Settings opened: \(success)")
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MyCollectionViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgPicke = info[.editedImage] ?? info[.originalImage] {
            if let img = imgPicke as? UIImage {
                // Save the selected image
                saveImage(image: img)
                selectedCell?.imageView.image = img
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save and Load Image
    private func saveImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("savedImage.jpg")
        do {
            try imageData.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    private func loadSavedImage() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("savedImage.jpg")
        if let imageData = try? Data(contentsOf: fileURL) {
            selectedCell?.imageView.image = UIImage(data: imageData)
        }
    }
}
