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
    var cellId:String
    
    init(name:String, cellType: UITableViewCell.Type){
        self.name = name
        self.cellType = cellType
        cellId = "\(cellType.self)\(name)"
    }
}

public struct ConfigureTable{
    var items:[[Field]]
    var configureCell:(_ cell:UITableViewCell, _ item:Field)->()
    var selectedRow:(_ form:FormViewController, _ indexPath:IndexPath)->()
}

class FormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items:[[Field]]
    var sections:[[UITableViewCell]]
    var selectedRow:(_ form:FormViewController, _ indexPath:IndexPath)->()
    var configureCell:(_ cell:UITableViewCell, _ item:Field)->()
    var buildCellsDone:(()->())?
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        tv.autoresizingMask  = [.flexibleWidth, .flexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    init(config:ConfigureTable){
        self.items = config.items
        self.configureCell = config.configureCell
        self.selectedRow = config.selectedRow
        self.sections = [[UITableViewCell]]()
        super.init(nibName: nil, bundle: nil)
        self.buildCells()
    }
    
    func buildCells(){
        for section in self.items{
            var c = [UITableViewCell]()
            for it in section {
                let instance = it.cellType.init(style: .default, reuseIdentifier: it.cellId)
                instance.textLabel?.text = "\(it.name)"
                c.append(instance)
            }
            self.sections.append(c)
        }
    }
    
    func incrementIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        var nextIndexPath: IndexPath?
        let rowCount = tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section)
        let nextRow = (indexPath as NSIndexPath).row + 1
        let currentSection = (indexPath as NSIndexPath).section
        
        if nextRow < rowCount {
            nextIndexPath = IndexPath(row: nextRow, section: currentSection)
        }
        else {
            let nextSection = currentSection + 1
            if nextSection < tableView.numberOfSections {
                nextIndexPath = IndexPath(row: 0, section: nextSection)
            }
        }
        return nextIndexPath
    }
    
    func getFormData()->[String:AnyObject]{
        var result = [String:AnyObject]()
        var index:IndexPath? = IndexPath(row: 0, section: 0)
        while index != nil {
            let cell = self.tableView.cellForRow(at: index!)
            if cell is TextCell {
                let key = cell!.textLabel!.text!
                let value = (cell as! TextCell).textField.text
                result[key] = value as AnyObject?
            } else if cell is NumberCell {
                let key = cell!.textLabel!.text!
                let value = (cell as! NumberCell).nf.text
                result[key] = value as AnyObject?
            }
            index = self.incrementIndexPath(index!)
        }
        return result
    }
    
    func setFormData(data:[String:AnyObject]){
        let f = DateFormatter()
        f.dateStyle = .medium
        
        let nf = NumberFormatter()
        for (key, value) in data {
            for cell in tableView.visibleCells  {
                if cell is TextCell {
                    if  cell.textLabel!.text == key {
                        if (cell is DateCell) {
                            (cell as! DateCell).datePicker.date = value as! Date
                            (cell as! DateCell).textField.text! = f.string(from: value as! Date)
                        } else if (cell is IntCell) {
                            (cell as! IntCell).textField.text! = nf.string(from: value as! NSNumber)!
                        } else if (cell is LinkCell) {
                            // (cell as! Link).textField.text! = value as! String
                        } else if (cell is TextCell) {
                            (cell as! TextCell).textField.text! = value as! String
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).item]
        let item = items[indexPath.section][indexPath.item]
        configureCell(cell, item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow(self, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 6 : 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == tableView.indexPathsForVisibleRows?.last {
            self.buildCellsDone?()
        }
    }
}
