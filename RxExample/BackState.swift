//
//  BackState.swift
//  RxExample
//
//  Created by Steven Chan on 30/4/2016.
//  Copyright © 2016 oursky. All rights reserved.
//

import UIKit
import RxSwift

let AppBackState = BackState()

struct SearchResultType {
    let progress: Float
    let result: [String]
}

struct SearchVariable {
    let keywords = Variable<String>("")
    let searchResult = Variable<SearchResultType>(SearchResultType(progress: 0.0, result: [String]()))
}

struct BackState {
    let stackOverflowSearch = SearchVariable()
}
