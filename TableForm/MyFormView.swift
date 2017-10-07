//
//  MyFormView.swift
//  TableForm
//
//  Created by Gazolla on 05/10/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class MyFormViewController: FormViewController {
    
    var gender:String? {
        didSet{
               if let cell = self.sections?[2][0], let gender = self.gender {
                    (cell as! LinkCell).valueLabel.text = gender
                }
            }
    }

    func createFieldsAndSections()->[[Field]]{
        let name = Field(name:"name", title:"Name:", cellType: NameCell.self)
        let birth = Field(name:"birthday", title:"Birthday:", cellType: DateCell.self)
        let address = Field(name:"address", title:"Address:", cellType: TextCell.self)
        let sectionPersonal = [name, address, birth]
        let company = Field(name:"company", title:"Company:", cellType: TextCell.self)
        let position = Field(name:"position", title:"Position:", cellType: TextCell.self)
        let salary = Field(name:"salary", title:"Salary:", cellType: NumberCell.self)
        let sectionProfessional = [company, position, salary]
        let gender = Field(name: "gender", title:"Gender:", cellType: LinkCell.self)
        let sectionGender = [gender]
        return [sectionPersonal, sectionProfessional, sectionGender]
    }
    
    lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }()
    
    lazy var genderList = { ()-> TableViewController<String> in
        let genders = ["male", "female"]
        let genderList = TableViewController(items:genders, cellType: UITableViewCell.self)
        
        genderList.configureCell = { (cell, item, indexPath) in
            cell.textLabel?.text = "\(item)"
        }
        
        genderList.selectedRow = { (controller, indexPath) in
            if let cell  = controller.tableView.cellForRow(at: indexPath as IndexPath){
                cell.accessoryType = .checkmark
                controller.selected = indexPath
                self.gender = cell.textLabel?.text
            }
            controller.navigationController?.popViewController(animated: true)
        }
        
        genderList.deselectedRow = { (controller, indexPath) in
            if controller.selected != nil {
                if let cell  = controller.tableView.cellForRow(at: controller.selected!){
                    cell.accessoryType = .none
                }
            }
        }
        
        genderList.title = "Venues"
        
        return genderList
    }()
    
    override init(){
        super.init()
        let its = createFieldsAndSections()
        self.items = its
        self.sections = buildCells(items: its)
        self.selectedRow = { [weak self] (form:FormViewController,indexPath:IndexPath) in
            let cell = form.tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
            if cell is LinkCell {
                if (cell as! FormCell).name == "gender" {
                    self?.navigationController?.pushViewController(self!.genderList, animated: true)
                }
            }
        }
    }
    
    override init(config:ConfigureForm){
        super.init(config:config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Employee"
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func saveTapped(){
        let dic = self.getFormData()
        let alertController = UIAlertController(title: "Form Data", message: dic.description, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
}
