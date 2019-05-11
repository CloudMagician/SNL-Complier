//
//  ViewController.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/8.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TextView.sizeThatFits(CGSize.init(width: TextView.frame.size.width, height: TextView.frame.size.height))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ScrollView.layoutIfNeeded()
        self.ScrollView.contentSize = self.TextView.bounds.size
    }
}

