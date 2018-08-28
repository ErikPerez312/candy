//
//  HomeComponent+Permissions.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs
import AVFoundation

/// The dependencies needed from the parent scope of Home to provide for the Permissions scope.
// Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyPermissions: Dependency {
    // Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the Permissions scope.
}

extension HomeComponent: PermissionsDependency {
    // Implement properties to provide for Permissions scope.
    var cameraAccessStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    var microphoneAccessStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
}
