//
//  AppComponent.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
