//
//  YPPermissionDeniedPopup.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 12/03/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit

enum PermissionType {
    case library
    case camera
    case microphone
    
    var localizedMessage: String {
        switch self {
        case .camera:
            return YPConfig.wordings.permissionPopup.cameraMessage
        case .library:
            return YPConfig.wordings.permissionPopup.libraryMessage
        case .microphone:
            return YPConfig.wordings.permissionPopup.microphoneMessage
        }
    }
}

class YPPermissionDeniedPopup: UIAlertController {
    
    var onCancelTapped: (() -> Void)?
    
    private var permissionType: PermissionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setup(for permissionType: PermissionType) {
        
        self.permissionType = permissionType
    }
    
    private func setupUI() {
        
        title = YPConfig.wordings.permissionPopup.title
        message = permissionType?.localizedMessage

        let cancelAction = UIAlertAction(title: YPConfig.wordings.cancel, style: .cancel) { _ in
            self.onCancelTapped?()
        }
        
        let settingsAction = UIAlertAction(title: YPConfig.wordings.permissionPopup.settings, style: .default) { _ in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        
        addAction(cancelAction)
        addAction(settingsAction)
    }
}
