//
//  LoggedOutComponent+Register.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of LoggedOut to provide for the Register scope.
// TODO: Update LoggedOutDependency protocol to inherit this protocol.
protocol LoggedOutDependencyRegister: Dependency {
    // TODO: Declare dependencies needed from the parent scope of LoggedOut to provide dependencies
    // for the Register scope.
}

extension LoggedOutComponent: RegisterDependency {

    // TODO: Implement properties to provide for Register scope.
}
