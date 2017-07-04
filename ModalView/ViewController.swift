//
//  ViewController.swift
//  ModalView
//
//  Created by Myron on 2017/7/3.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    let modalview = ModalView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalview.display(to: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

