//
//  RootComponent+Home.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the Home scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyHome: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the Home scope.
}

extension RootComponent: HomeDependency {

    // TODO: Implement properties to provide for Home scope.
}