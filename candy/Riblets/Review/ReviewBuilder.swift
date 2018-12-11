//
//  ReviewBuilder.swift
//  candy
//
//  Created by Erik Perez on 12/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

protocol ReviewDependency: Dependency {
    // Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ReviewComponent: Component<ReviewDependency> {
    // Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ReviewBuildable: Buildable {
    func build(withListener listener: ReviewListener) -> ReviewRouting
}

final class ReviewBuilder: Builder<ReviewDependency>, ReviewBuildable {

    override init(dependency: ReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReviewListener) -> ReviewRouting {
        let component = ReviewComponent(dependency: dependency)
        let viewController = ReviewViewController()
        let interactor = ReviewInteractor(presenter: viewController)
        interactor.listener = listener
        return ReviewRouter(interactor: interactor, viewController: viewController)
    }
}
