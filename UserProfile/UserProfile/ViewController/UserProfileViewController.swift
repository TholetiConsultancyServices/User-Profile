//
//  UserProfileViewController.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import UIKit
class UserProfileViewController: UIViewController {
    
    @IBOutlet fileprivate  weak var avatarImageView: UIImageView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    var presenter: UserProfilePresenter?
    fileprivate var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(self.profilePhotoTapped(_:)))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(logut))
        fetchData()
    }
    
    
    @objc func logut() {
        AppManager.shareInstance.logout()
    }
    
    // MARK: private
    fileprivate func showFetchDataInProgressView(){
        transparentView.isHidden = false
        transparentView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        indicatorView.startAnimating()
    }
    
    fileprivate func hideFetchDataInProgressView() {
        transparentView.isHidden = true
        indicatorView.stopAnimating()
    }
    
    @objc private func fetchData() {
        showFetchDataInProgressView()
        presenter?.fetchUserProfile(fetchUserProfileCompletionHandler: {[weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideFetchDataInProgressView()
            switch result {
            case .Success(let viewModel):
                strongSelf.avatarImageView.image = viewModel.profilePhoto
                strongSelf.emailTextField.text = viewModel.email
                strongSelf.passwordTextField.text = viewModel.password
            case .Failure(let error):
                strongSelf.showLoadDataFailedAlert(withMessage: error)
                break;
            }
        })
    }
    
    private func showLoadDataFailedAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Loading user profile failed",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action  ) in
            self.fetchData()
        }
        
        alert.addAction(okAction)
         alert.addAction(retryAction)
        present(alert, animated: true)
    }
    
    @objc func profilePhotoTapped(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Profile photo",
                                      message: "Choose photo from camera or photo library",
                                      preferredStyle: .alert)
        let photoLibraryAction = UIAlertAction(title: "Photo Lbrary", style: .default) { (action  ) in
            self.showImagePickerOption(for: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action  ) in
            self.showImagePickerOption(for: .camera)
        }
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        present(alert, animated: true)
    }
    
    private func showImagePickerOption( for sourceType: UIImagePickerControllerSourceType) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: UIImagePickerControllerDelegate methods
extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func uploadPhotoFailedAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Upload photo failed",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        let profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        guard let photo = profileImage else {
            return
        }
        dismiss(animated: true, completion: nil)
        showFetchDataInProgressView()
        presenter?.uploadProfilePhoto(photo: photo, uploadProfilePhotoCompletionHandler: {[weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideFetchDataInProgressView()
            switch result {
            case .Success(_):
                strongSelf.avatarImageView.image = profileImage
            case .Failure(let error):
                strongSelf.uploadPhotoFailedAlert(withMessage: error)
            }
        })
    }
}


