//
//  ViewController.swift
//  SwiftAppDemo
//
//  Created by ZP on 2021/5/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func sum(a: Int, b: Int) -> Int {
        return a + b
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(sum(a: 10, b: 20))
    }
}
