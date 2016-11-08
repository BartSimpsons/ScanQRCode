//
//  ViewController.swift
//  ScanQRCode
//
//  Created by simpsons on 2016/11/8.
//  Copyright © 2016年 simpsons. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func scanCode(_ sender: AnyObject) {
        
        self.navigationController?.pushViewController(QRCode(), animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

