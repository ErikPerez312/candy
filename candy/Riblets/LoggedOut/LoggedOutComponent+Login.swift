//
//  LoggedOutComponent+Login.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of LoggedOut to provide for the Login scope.
protocol LoggedOutDependencyLogin: Dependency {
    // Declare dependencies needed from the parent scope of LoggedOut to provide dependencies
    // for the Login scope.
}

extension LoggedOutComponent: LoginDependency {
    // Implement properties to provide for Login scope.
}
