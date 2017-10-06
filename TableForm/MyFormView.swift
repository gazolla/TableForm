//
//  MyFormView.swift
//  TableForm
//
//  Created by Gazolla on 05/10/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class MyFormViewController: FormViewController {

    func createFieldsAndSections()->[[Field]]{
        let name = Field(name:"name", title:"Name:", cellType: NameCell.self)
        let birth = Field(name:"birthday", title:"Birthday:", cellType: DateCell.self)
        let address = Field(name:"address", title:"Address:", cellType: TextCell.self)
        let sectionPersonal = [name, address, birth]
        let company = Field(name:"company", title:"Company:", cellType: TextCell.self)
        let position = Field(name:"position", title:"Position:", cellType: TextCell.self)
        let salary = Field(name:"salary", title:"Salary:", cellType: NumberCell.self)
        let sectionProfessional = [company, position, salary]
        let slider = Field(name: "test", title:"test:", cellType: SliderCell.self)
        let sectionSlider = [slider]
        let swap = Field(name: "cool", title:"Is it cool?", cellType: SwitchCell.self)
        let sectionSwap = [swap]
        let stepper = Field(name: "count", title:"Count:", cellType: StepperCell.self)
        let sectionStepper = [stepper]
        return [sectionPersonal, sectionProfessional, sectionSlider, sectionSwap, sectionStepper]
    }
    
    lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }()
    
    override init(){
        super.init()
        let its = createFieldsAndSections()
        self.items = its
        self.sections = buildCells(items: its)
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
