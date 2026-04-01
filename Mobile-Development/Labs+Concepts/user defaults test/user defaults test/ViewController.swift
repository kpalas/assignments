//
//  ViewController.swift
//  user defaults test
//
//  Created by Kian Palas on 21/11/2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    if let userName = UserDefaults.standard.string(forKey: "name") {
        print("Previously saved username is \"\(userName)\"")
        } else {
        print("No username previously saved")
        }
        UserDefaults.standard.set(nil, forKey: "name")
    }


}

