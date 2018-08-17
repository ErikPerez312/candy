//
//  RootComponent+LoggedOut.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedOut scope.
protocol RootDependencyLoggedOut: Dependency {
    // Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the LoggedOut scope.
}

extension RootComponent: LoggedOutDependency {
    // Implement properties to provide for LoggedOut scope.
    
    var loggedOutViewController: LoggedOutViewControllable {
        return rootViewController
    }
}
