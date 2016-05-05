//
//  ViewController.swift
//  RxExample
//
//  Created by Steven Chan on 30/4/2016.
//  Copyright © 2016 oursky. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag: DisposeBag = DisposeBag()

    let input = UITextField()

    let inputCountLabel = UILabel()
    let resultCountLabel = UILabel()

    var result = [String]()
    let resultTableView = UITableView()

    let backState: BackState = AppBackState
    let viewModel = AppFrontState.stackOverflowSearchViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor.whiteColor()

        self.inputCountLabel.backgroundColor = UIColor.yellowColor()

        self.resultTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.resultTableView.dataSource = self

        self.view.addSubview(self.inputCountLabel)
        self.view.addSubview(self.resultCountLabel)
        self.view.addSubview(self.input)
        self.view.addSubview(self.resultTableView)

        self.driveBackState()
        self.subscribeFrontState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func updateViewConstraints() {
        self.inputCountLabel.snp_updateConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(self.topLayoutGuide.length)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }

        self.resultCountLabel.snp_updateConstraints { (make) in
            make.left.equalTo(self.inputCountLabel.snp_right)
            make.top.equalTo(self.topLayoutGuide.length)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }

        self.input.snp_updateConstraints { (make) in
            make.left.equalTo(self.resultCountLabel.snp_right)
            make.right.equalTo(0)
            make.top.equalTo(self.topLayoutGuide.length)
            make.height.equalTo(44)
        }

        self.resultTableView.snp_updateConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(self.input.snp_bottom)
        }

        super.updateViewConstraints()
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.result[indexPath.row]
        return cell
    }

}
