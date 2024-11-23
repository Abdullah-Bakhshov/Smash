//
//  DevicePermissions.swift
//  Smash
//
//  Created by Abdullah B on 05/11/2024.
//

import SwiftUI
import AVFoundation

// Allows main thread to always contain the changes and that would be the isvideopermision granted
//@MainActor
class PermissionManager {
    // In swift the async variables or tasks will be put into a thread pool which then allows for swift to handle the tasks without actually context switching reducing the overhead making you carry out the task faster.
    var permisionforvideo: Bool {
        get async {
            // Status will get the status of the device and store it in the static variable
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            // Permissionforvideo is then equal to the bool of if the current device status and if its the same as the authorised status
            var permissionforvideo = status == .authorized
            // if we get that the status is undeturmined then we wait for the person to accept the video permission
            if status == .notDetermined {
                permissionforvideo = await AVCaptureDevice.requestAccess(for: .video)
            }
            // return the bool if we can use or not use the video
            return permissionforvideo
        }
    }
    
    var permisionformicrophone: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            var permissionformicrophone = status == .authorized
            if status == .notDetermined {
                permissionformicrophone = await AVCaptureDevice.requestAccess(for: .audio)
            }
            return permissionformicrophone
        }
    }
}



#Preview {
    //    DevicePermissions()
}
