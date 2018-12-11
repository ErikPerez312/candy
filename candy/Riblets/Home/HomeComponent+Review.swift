//
//  HomeComponent+Review.swift
//  candy
//
//  Created by Erik Perez on 12/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

// Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyReview: Dependency {
    // Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the Review scope.
}

extension HomeComponent: ReviewDependency {
    // Implement properties to provide for Review scope.
}
