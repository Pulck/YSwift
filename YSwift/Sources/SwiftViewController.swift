//
//  SwiftViewController.swift
//  YSwift
//
//  Created by UWLiang on 2020/11/18.
//

import UIKit
import PHUIKit

public class SwiftViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = PHButton(type: .big)
        button.setTitle("Swift", for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
