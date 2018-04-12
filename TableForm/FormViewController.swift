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
    var fields:[[Field]]
    var selectedRow:((_ form:FormViewController, _ indexPath:IndexPath)->())?
    var configureCell:((_ cell:FormCell, _ item:Field)->())?

    init (fields:[[Field]], selectedRow:((_ form:FormViewController, _ indexPath:IndexPath)->())?=nil, configureCell:((_ cell:UITableViewCell, _ item:Field)->())?=nil){
        self.fields = fields
        self.selectedRow = selectedRow
        self.configureCell = configureCell
    }
}


class FormViewController: UIViewController {
    
    var hiddenData:[String:AnyObject?]?
    var fields:[[Field]]?
    var sections:[[FormCell]]?
    var selectedRow:((_ form:FormViewController, _ indexPath:IndexPath)->())?
    var configureCell:((_ cell:FormCell, _ item:Field)->())?
    var buildCellsDone:(()->())? 
    var data:[String:AnyObject?]?
    
    
    lazy var tableView:FormView = {
        let tv = FormView(frame: self.view.bounds, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        
        tv.completion = {
            DispatchQueue.main.async {
                if self.data != nil {
                    self.setFormData()
                }
            }
        }
        return tv
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(config:ConfigureForm){
        self.fields = config.fields
        self.selectedRow = config.selectedRow
        super.init(nibName: nil, bundle: nil)
        self.configureCell = config.configureCell
        if let its = self.fields {
            self.sections = self.buildCells(items: its)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildCells(items:[[Field]])->[[FormCell]]?{
        var secs = [[FormCell]]()
        for section in items{
            var c = [FormCell]()
            for it in section {
                let instance = it.cellType.init(style: .default, reuseIdentifier: it.cellId) as! FormCell
                instance.name = it.name
                instance.textLabel?.text = "\(it.title)"
                c.append(instance)
            }
            secs.append(c)
        }
        return secs
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
    
    func getFormData()->[String:AnyObject?]{
        if self.data == nil { self.data = [String:AnyObject?]() }
        var index:IndexPath? = IndexPath(row: 0, section: 0)
        while index != nil {
            let cell = self.tableView.cellForRow(at: index!)
            if cell is FormCell {
                let tuple = (cell as! FormCell).getCellData()
                self.data![tuple.key] = tuple.value as AnyObject?
            }
            index = self.incrementIndexPath(index!)
        }
        if let hiddenData = hiddenData {
            if hiddenData.count > 0{
                for (key, value) in hiddenData {
                    data![key] = value
                }
            }
        }
        print(data!)
        return self.data!
    }
    
    func setFormData(){
        guard let sections = self.sections else { return }
        for (key, value) in self.data! {
            var index:IndexPath? = IndexPath(row: 0, section: 0)
            while index != nil {
                let cell = sections[(index! as NSIndexPath).section][(index! as NSIndexPath).item]
                if  cell.name == key && value != nil {
                    cell.setCellData(key: key, value: value!)
                }
                index = self.incrementIndexPath(index!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterObservers()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
    
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEnd(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
    }
    
    func unregisterObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
    }
    
    @objc func textFieldTextDidEnd(_ sender: NSNotification) {
        _ = self.getFormData()
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        tableView.contentInset.bottom = keyboardSize
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        tableView.contentInset.bottom = 0
        _ = self.getFormData()
    }

}

extension FormViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = self.sections?[indexPath.section] else { return 0.0 }
        let cell = section[indexPath.item]
        if (cell is SliderCell) {
            return 70
        } else if (cell is ButtonCell) {
            return 60
        } else if ((cell is TextViewCell) || (cell is ImageCell)){
            return 140
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let item = sections?[section][0] else { return 0.0 }
        if item is ButtonCell {
            return 20
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let item = sections?[section][0] else { return 0.0 }
        if item is ButtonCell {
            return 20
        } else {
            return 3
        }
    }
}

extension FormViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections")
        print("sections: \(self.sections?.count ?? -1)")
        if self.sections == nil  { return 0 }
        return self.fields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        print("sections: \(self.sections?.count ?? -1)")
        if self.sections == nil { return 0 }
        return self.fields?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = self.fields, let sections = self.sections else { return UITableViewCell() }
        let cell = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).item]
        let item = items[indexPath.section][indexPath.item]
        configureCell?(cell, item)
        if indexPath.row + 1 == items[indexPath.section].count {
            cell.tag = 999
        } else {
            cell.tag = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            if cell is TextCell{
                if ((cell as! TextCell).textField.isFirstResponder) == true{
                    (cell as! TextCell).textField.resignFirstResponder()
                }
            }
        }
        selectedRow?(self, indexPath)
    }
}

