//
//  ViewController+Reactive.swift
//  RxExample
//
//  Created by Steven Chan on 1/5/2016.
//  Copyright © 2016 oursky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension ViewController {

    func driveBackState() {
        let inputObservable = input.rx_text
            .distinctUntilChanged()

        inputObservable
            .asDriver(onErrorJustReturn: "")
            .drive(AppBackState.stackOverflowSearch.keywords)
            .addDisposableTo(self.disposeBag)

        inputObservable
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { $0.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! }
            .flatMap(searchStackOverflow)
            .debug()
            .asDriver(onErrorJustReturn: (0.0, nil))
            .debug()
            .map { SearchResultType(progress: $0.0, result: stackOverflowResultMapper($0.1)) }
            .drive(AppBackState.stackOverflowSearch.searchResult)
            .addDisposableTo(self.disposeBag)
    }

    func subscribeFrontState() {
        self.viewModel.filteredKeywords
            .bindTo(self.input.rx_text)
            .addDisposableTo(self.disposeBag)

        self.viewModel.wordCount
            .map { String($0) }
            .bindTo(self.inputCountLabel.rx_text)
            .addDisposableTo(self.disposeBag)

        self.viewModel.result
            .bindNext {
                self.result = $0
                self.resultTableView.reloadData()
            }
            .addDisposableTo(self.disposeBag)

        self.viewModel.resultCount
            .map { String($0) }
            .bindTo(self.resultCountLabel.rx_text)
            .addDisposableTo(self.disposeBag)

        self.viewModel.keywordsTextColor
            .bindNext { self.input.textColor = $0 }
            .addDisposableTo(self.disposeBag)

        self.viewModel.resultCountBackgroundColor
            .bindNext { self.resultCountLabel.backgroundColor = $0 }
            .addDisposableTo(self.disposeBag)
    }
}
