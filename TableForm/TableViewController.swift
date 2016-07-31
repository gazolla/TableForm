//
//  TableViewController.swift
//  TableForm
//
//  Created by Gazolla on 25/07/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

public struct Field{
    var name:String
    var cellType:UITableViewCell.Type
    var cellId:String = ""
    
    init(name:String, cellType: UITableViewCell.Type){
        self.name = name
        self.cellType = cellType
        cellId = String(cellType.self)
    }
}

public struct ConfigureTable{
    var items:[[Field]]
    var selectedRow:(tableView:TableViewController, indexPath:NSIndexPath)->()
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items:[[Field]]
    var sections:[[UITableViewCell]]
    var selectedRow:(tableView:TableViewController, indexPath:NSIndexPath)->()
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .Grouped)
       // tv.allowsSelection = false
        tv.autoresizingMask  = [.FlexibleWidth, .FlexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    init(config:ConfigureTable){
        self.items = config.items
        self.selectedRow = config.selectedRow
        self.sections = [[UITableViewCell]]()
        super.init(nibName: nil, bundle: nil)
        self.buildCells()
     }
    
    func buildCells(){
        for section in self.items{
            var c = [UITableViewCell]()
            for it in section {
                let instance = it.cellType.init(style: .Default, reuseIdentifier: it.cellId)
                instance.textLabel?.text = "\(it.name)"
                c.append(instance)
            }
            self.sections.append(c)
        }
    }
    
    func incrementIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        var nextIndexPath: NSIndexPath?
        let rowCount = tableView.numberOfRowsInSection(indexPath.section)
        let nextRow = indexPath.row + 1
        let currentSection = indexPath.section
        
        if nextRow < rowCount {
            nextIndexPath = NSIndexPath(forRow: nextRow, inSection: currentSection)
        }
        else {
            let nextSection = currentSection + 1
            if nextSection < tableView.numberOfSections {
                nextIndexPath = NSIndexPath(forRow: 0, inSection: nextSection)
            }
        }
        
        return nextIndexPath
    }
    
    func getFormData()->[String:AnyObject]{
        var result = [String:AnyObject]()
        var index:NSIndexPath? = NSIndexPath(forRow: 0, inSection: 0)
        while index != nil {
            let cell = self.tableView.cellForRowAtIndexPath(index!)
            if cell is TextCell {
                let key = cell!.textLabel!.text!
                let value = (cell as! TextCell).textField.text
                result[key] = value
            }
            index = self.incrementIndexPath(index!)
        }
        return result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.sections[indexPath.section][indexPath.item]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow(tableView: self, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 6 : 3
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
}
