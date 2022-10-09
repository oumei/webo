//
//  WBComposeViewController.swift
//  webo
//
//  Created by OMi on 2021/5/14.
//

import UIKit

class WBComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", target: self, action: #selector(close))
    }
    

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    

}
