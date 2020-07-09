//
//  PermissionCheckable.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 25/01/2018.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import UIKit
import AVFoundation

protocol YPPermissionCheckable {
    func checkPermission()
}

extension YPPermissionCheckable where Self: UIViewController {
    
    func checkPermission() {
        checkPermissionToAccessVideo { _ in }
    }
    
    func doAfterPermissionCheck(block:@escaping () -> Void) {
        checkPermissionToAccessVideo { hasPermission in
            if hasPermission {
                block()
            }
        }
    }
    
    // Async beacause will prompt permission if .notDetermined
    // and ask custom popup if denied.
    func checkPermissionToAccessVideo(block: @escaping (Bool) -> Void) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            
            switch AVAudioSession.sharedInstance().recordPermission {
            case .denied, .undetermined:
                let alert = YPPermissionDeniedPopup.popup(for: .microphone, cancelBlock: {
                    block(true)
                })
                present(alert, animated: true, completion: nil)
                
            case .granted:
                block(true)
                
            @unknown default:
                NSLog("Microphone permission case not handled")
                fatalError()
            }
            
        case .restricted, .denied:
            let alert = YPPermissionDeniedPopup.popup(for: .camera, cancelBlock: {
                block(false)
            })
            present(alert, animated: true, completion: nil)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    block(granted)
                }
            })
            
        @unknown default:
            fatalError()
        }
    }
}
