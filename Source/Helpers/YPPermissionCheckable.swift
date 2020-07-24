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
    
    func doAfterCameraPermissionCheck(completion: @escaping (Bool) -> Void) {
        
        checkPermissionToAccessVideo(completion: completion)
    }
    
    func doAfterVideoPermissionCheck(completion: @escaping (Bool) -> Void) {
        
        checkPermissionToAccessVideo { hasVideoPermission in
            if hasVideoPermission {
                self.checkPermissionToAccessMicrophone(completion: completion)
            } else {
                completion(false)
            }
        }
    }
    
    // Async beacause will prompt permission if .notDetermined
    // and ask custom popup if denied.
    func checkPermissionToAccessVideo(completion: @escaping (Bool) -> Void) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
            
        case .restricted, .denied:
            let alert = UIAlertController.permissionDeniedAlert(forType: .camera, onCancel: {
                completion(false)
            })
            
            present(alert, animated: true, completion: nil)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
            
        @unknown default:
            NSLog("Video permission case not handled")
            fatalError()
        }
    }
    
    func checkPermissionToAccessMicrophone(completion: @escaping (Bool) -> Void) {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
            
        case .denied:
            let alert = UIAlertController.permissionDeniedAlert(forType: .microphone, onCancel: {
                completion(false)
            })

            present(alert, animated: true, completion: nil)
            
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        @unknown default:
            NSLog("Microphone permission case not handled")
            fatalError()
        }
    }
}
