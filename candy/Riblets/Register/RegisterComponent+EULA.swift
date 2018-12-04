//
//  RegisterComponent+EULA.swift
//  candy
//
//  Created by Erik Perez on 11/24/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Register to provide for the EULA scope.
// Update RegisterDependency protocol to inherit this protocol.
protocol RegisterDependencyEULA: Dependency {
    // Declare dependencies needed from the parent scope of Register to provide dependencies
    // for the EULA scope.
}

extension RegisterComponent: EULADependency {
    // Implement properties to provide for EULA scope.
}
