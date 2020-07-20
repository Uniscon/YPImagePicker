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

extension UIAlertController {
    
    class func permissionDeniedAlert(forType permissionType: PermissionType,
                                     onCancel: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: YPConfig.wordings.permissionPopup.title,
                                      message: permissionType.localizedMessage,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: YPConfig.wordings.cancel, style: .cancel) { _ in
            onCancel?()
        }

        let settingsAction = UIAlertAction(title: YPConfig.wordings.permissionPopup.settings, style: .default) { _ in

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(settingsAction)

        return alert
    }
}
