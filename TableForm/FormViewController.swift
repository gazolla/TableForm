//
//  FormViewController.swift
//  Form
//
//  Created by Gazolla on 10/03/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

public struct Field{
    var name:String
    var title:String
    var value:AnyObject?
    var cellType:UITableViewCell.Type
    var cellId:String
    
    init(name:String, title:String, cellType: UITableViewCell.Type){
        self.name = name
        self.title = title
        self.cellType = cellType
        cellId = "\(cellType.self)\(name)"
    }
}

public struct ConfigureForm{
    var items:[[Field]]
    var configureCell:(_ cell:UITableViewCell, _ item:Field)->()
    var selectedRow:(_ form:FormViewController, _ indexPath:IndexPath)->()
}


class FormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var items:[[Field]]
    var sections:[[FormCell]]
    var selectedRow:(_ form:FormViewController, _ indexPath:IndexPath)->()
    var configureCell:(_ cell:UITableViewCell, _ item:Field)->()
    var buildCellsDone:(()->())?
    var data:[String:AnyObject]?
    
    
    lazy var tableView:FormView = {
        let tv = FormView(frame: self.view.bounds, style: .grouped)
        tv.autoresizingMask  = [.flexibleWidth, .flexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        
        tv.completion = {
            if self.data != nil {
                self.setFormData()
            }
        }
        
        return tv
    }()
    
    init(config:ConfigureForm){
        self.items = config.items
        self.configureCell = config.configureCell
        self.selectedRow = config.selectedRow
        self.sections = [[FormCell]]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildCells(){
        for section in self.items{
            var c = [FormCell]()
            for it in section {
                let instance = it.cellType.init(style: .default, reuseIdentifier: it.cellId) as! FormCell
                instance.name = it.name
                instance.textLabel?.text = "\(it.title)"
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
        self.data = [String:AnyObject]()
        var index:IndexPath? = IndexPath(row: 0, section: 0)
        while index != nil {
            let cell = self.tableView.cellForRow(at: index!)
            if cell is FormCell {
                let tuple = (cell as! FormCell).getCellData()
                self.data![tuple.key] = tuple.value as AnyObject?
                print(tuple.value)
            }
            index = self.incrementIndexPath(index!)
        }
        return self.data!
    }
    
    func setFormData(){
        for (key, value) in self.data! {
            for cell  in tableView.visibleCells  {
                if  (cell as! FormCell).name == key {
                    if cell is FormCell {
                        (cell as! FormCell).setCellData(key: key, value: value)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildCells()
        self.view.addSubview(self.tableView)
        self.registerObservers()
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
        _ = getFormData()
        selectedRow(self, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 6 : 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        let cell = section[indexPath.item]
        if cell is SliderCell {
            return 70
        } else if cell is TextViewCell {
            return 140
        } else {
            return 44
        }
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ sender: NSNotification) {
        _ = self.getFormData()
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        tableView.contentInset.bottom = keyboardSize
    }
    
    func keyboardWillHide(_ sender: NSNotification) {
        _ = self.getFormData()
        tableView.contentInset.bottom = 0
    }

}
