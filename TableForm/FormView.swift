//
//  FormView.swift
//  Form
//
//  Created by Gazolla on 10/03/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class FormView: UITableView {

    var completion: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.completion?()
    }
    

}
