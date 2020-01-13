//
//  ViewController.swift
//  tt
//
//  Created by Mariano on 10/12/2019.
//  Copyright © 2019 Mariano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        start.setImage(UIImage(named: "butt@2x.png"), for: .normal )

        self.view.addSubview(self.start)

        // Do any additional setup after loading the view.
    }
    @IBAction func Start(_ sender: UIButton) {

        
    }
    

}

