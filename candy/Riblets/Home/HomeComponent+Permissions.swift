//
//  HomeComponent+Permissions.swift
//  candy
//
//  Created by Erik Perez on 8/27/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the Permissions scope.
protocol HomeDependencyPermissions: Dependency {
    // Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the Permissions scope.
    
}

extension HomeComponent: PermissionsDependency {
    // Implement properties to provide for Permissions scope.
}
