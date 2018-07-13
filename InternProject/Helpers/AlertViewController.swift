//
//  AlertViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/12/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
