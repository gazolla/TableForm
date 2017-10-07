//
//  TableViewController.swift
//  GenericTable2
//
//  Created by Sebastiao Gazolla Costa Junior on 04/08/16.
//  Copyright © 2016 Sebastiao Gazolla Costa Junior. All rights reserved.
//

import UIKit

public struct ConfigureTable<Item>{
    var items:[Item]
    var cellType:AnyClass
    var configureCell:(_ cell:UITableViewCell, _ item:Item, _ indexPath:IndexPath)->()
    var selectedRow:(_ controller:TableViewController<Item>, _ indexPath:IndexPath)->()
}

class TableViewController<Item>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items:[Item] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var error:Error?{
        didSet{
            print(error!)
        }
    }
    
    var cellType:AnyClass
    var configureCell:((_ cell:UITableViewCell, _ item:Item, _ indexPath:IndexPath)->())?
    var selectedRow:((_ controller:TableViewController<Item>, _ indexPath:IndexPath)->())?
    var deselectedRow:((_ controller:TableViewController<Item>, _ indexPath:IndexPath)->())?
    var selected:IndexPath?
    
    init(items:[Item], cellType:AnyClass){
        self.items = items
        self.cellType = cellType
        super.init(nibName: nil, bundle: nil)
    }
    
    init(config:ConfigureTable<Item>){
        self.items = config.items
        self.cellType = config.cellType
        self.configureCell = config.configureCell
        self.selectedRow = config.selectedRow
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.register(self.cellType, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //as! SummaryCell
        let item = self.items[indexPath.item]
        configureCell?(cell, item, indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow?(self, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deselectedRow?(self, indexPath)
    }
    
    
}
