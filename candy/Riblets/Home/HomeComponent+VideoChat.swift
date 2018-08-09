//
//  HomeComponent+VideoChat.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the VideoChat scope.
// TODO: Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyVideoChat: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the VideoChat scope.
}

extension HomeComponent: VideoChatDependency {

    // TODO: Implement properties to provide for VideoChat scope.
}
