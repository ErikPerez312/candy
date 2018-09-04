//
//  HomeComponent+VideoChat.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the VideoChat scope.
protocol HomeDependencyVideoChat: Dependency {
    // Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the VideoChat scope.
}

extension HomeComponent: VideoChatDependency {
    // Implement properties to provide for VideoChat scope.
}
