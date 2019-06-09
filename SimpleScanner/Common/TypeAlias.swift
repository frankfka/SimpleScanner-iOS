//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

// Callbacks
public typealias VoidCallback = () -> ()
public typealias TapIndexCallback = (Int) -> ()
public typealias FileNameCallback = (String) -> ()
public typealias PageSwitchCallback = (Int, Int) -> () // Original, Destination

public typealias DispatchFunction = (Action) -> Void
public typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> State?)
                                        -> (@escaping DispatchFunction) -> DispatchFunction