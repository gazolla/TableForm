//
//  TextCell.swift
//  TableForm
//
//  Created by Gazolla on 25/07/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit
import QuartzCore

open class FormCell:UITableViewCell {
    var name:String?

    lazy var space:UIView = {
        let v = UIView()
        v.widthAnchor.constraint(equalToConstant: self.bounds.width*0.001).isActive = true
        return v
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override  open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {   }
    
    func setCellData(key: String, value: AnyObject){  }
    
    func getCellData()-> (key: String, value: AnyObject){
        let key = ""
        let value = "" as AnyObject
        return(key, value)
    }
}


open class TextCell: FormCell, UITextFieldDelegate {
    
    var textField = UITextField()
    
    override func setup() {
        
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        self.textField.delegate = self
        self.textField.tag = 3
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textField)
        
        addConstraintsWithFormat("V:|-3-[v0]-3-|", views:self.textField)
        addConstraintsWithFormat("H:|-100-[v0]-5-|", views:self.textField)
        
        self.textField.textAlignment = .left
    }
    
    override  open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.becomeFirstResponder()
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setCellData(key: String, value: AnyObject){
        self.textField.text! = value as! String
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.textField.text as AnyObject
        return(key, value)
    }
    
    
}

open class NumberCell: FormCell, UITextFieldDelegate {
    
    var nf = UITextField()
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    var amountTypedString = ""
    
    override func setup() {
        
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        self.nf.delegate = self
        self.nf.tag = 3
        self.nf.translatesAutoresizingMaskIntoConstraints = false
        self.nf.placeholder = "0.00"
        self.nf.font = UIFont.systemFont(ofSize: 35)
        //self.nf.borderStyle = UITextBorderStyle.roundedRect
        self.nf.autocorrectionType = UITextAutocorrectionType.no
        self.nf.keyboardType = UIKeyboardType.numberPad
        self.nf.returnKeyType = UIReturnKeyType.done
        self.nf.clearButtonMode = UITextFieldViewMode.whileEditing
        self.nf.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.nf.textAlignment = NSTextAlignment.center
        self.addSubview(self.nf)
        
        addConstraintsWithFormat("V:|-3-[v0]-3-|", views:self.nf)
        addConstraintsWithFormat("H:|-100-[v0]-5-|", views:self.nf)
        
    }
    
    override  open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nf.becomeFirstResponder()
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count > 0 {
            amountTypedString += string
            let decNumber = NSDecimalNumber(value: Float(amountTypedString)! as Float).multiplying(by: 0.01)
            let newString = formatter.string(from: decNumber)!
            self.nf.text = newString
        } else {
            amountTypedString = String(amountTypedString.characters.dropLast())
            if amountTypedString.characters.count > 0 {
                let decNumber = NSDecimalNumber(value: Float(amountTypedString)! as Float).multiplying(by: 0.01)
                let newString = formatter.string(from: decNumber)!
                self.nf.text = newString
            } else {
                self.nf.text = "0.00"
            }
            
        }
        return false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        amountTypedString = ""
        return true
    }
    
    override func setCellData(key: String, value: AnyObject){
        let strValue = value as! String
        self.nf.text! = strValue
        let filter   = NSCharacterSet(charactersIn:"0123456789.")
        let filteredValue = strValue.components(separatedBy:filter.inverted).joined(separator: "")

         amountTypedString = filteredValue
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.nf.text as AnyObject
        return(key, value)
    }
    
    
}

open class IntCell : TextCell {
    
    override func setup() {
        super.setup()
        textField.textAlignment = .right
        
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
    }
    
    override func setCellData(key: String, value: AnyObject){
        let nf = NumberFormatter()
        self.textField.text! = nf.string(from: value as! NSNumber)!
    }
    
}

open class PhoneCell : TextCell {
    
    override func setup() {
        super.setup()
        textField.keyboardType = .phonePad
    }
}

open class NameCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.keyboardType = .asciiCapable
    }
}

open class EmailCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
    }
}

open class PasswordCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
    }
}

open class DecimalCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
    }
}

open class URLCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .URL
    }
}

open class TwitterCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .twitter
    }
}

open class AccountCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
    }
}

open class ZipCodeCell : TextCell {
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.keyboardType = .numbersAndPunctuation
    }
}

open class DateCell : TextCell {
    
    var update:((_ date:Date)->())?
    
    var datePicker = UIDatePicker()
    var formatter:DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
    
    override func setup() {
        super.setup()
        
        self.textField.textAlignment = .right
        
        accessoryType = .none
        editingAccessoryType =  .none
        datePicker.datePickerMode = UIDatePickerMode.date
        self.textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(DateCell.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    deinit {
        datePicker.removeTarget(self, action: nil, for: .allEvents)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        self.textField.text = formatter.string(from: sender.date)
        // self.update?(sender.date)
    }
    
    override func setCellData(key: String, value: AnyObject){
        let f = DateFormatter()
        f.dateStyle = .medium
        if let vl = value as? String {
            if let dt = f.date(from: vl ){
                self.datePicker.date = dt
            }
            self.textField.text! = vl
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.update?(self.datePicker.date)
    }
    
    
}

open class ButtonCell: FormCell, UITextFieldDelegate {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override  open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func setup() {
        textLabel?.textColor = tintColor
        selectionStyle = .default
        accessoryType = .none
        editingAccessoryType = accessoryType
        textLabel?.textAlignment = .center
    }
}


open class LinkCell : UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override  open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    fileprivate func setup() {
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        
        // self.label.textColor = UIColor.darkOrange()
        self.label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        self.label.tag = 3
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)
        
        addConstraintsWithFormat("V:|-3-[v0]-3-|", views:self.label)
        addConstraintsWithFormat("H:|-100-[v0]-35-|", views:self.label)
        
        self.label.textAlignment = .right
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        editingAccessoryType =  .none
    }
    
    
}


open class SliderCell: FormCell {
    
    lazy var slider:UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 100
        s.isContinuous = true
        s.tintColor = UIColor.green
        s.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        s.widthAnchor.constraint(equalToConstant: self.bounds.width*0.9).isActive = true
        return s
    }()
    
    lazy var titleLabel:UILabel = {
        let l = self.getLabel()
        return l
    }()
    
    lazy var minLabel:UILabel = {
        let l = self.getLabel()
        return l
    }()
    
    lazy var maxLabel:UILabel = {
        let l = self.getLabel()
        return l
    }()
    
    lazy var valueLabel:UILabel = {
        let l = self.getLabel()
        l.textColor = UIColor.lightGray
        l.font =  UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        l.text = "00 %"
        return l
    }()
    
    lazy var sliderStack:UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .fillProportionally
        s.alignment = .fill
        s.spacing = 0
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(self.minLabel)
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(self.slider)
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(self.maxLabel)
        s.addArrangedSubview(UIView())
        return s
    }()
    
    
    lazy var mainStack:UIStackView = {
        print("main")
        let s = UIStackView(frame: self.bounds)
        s.axis = .vertical
        s.distribution = .fill
        s.alignment = .fill
        s.spacing = 0
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.addArrangedSubview(self.titleLabel)
        s.addArrangedSubview(self.sliderStack)
        s.addArrangedSubview(self.valueLabel)
        return s
    }()
    
    override func setup() {
        self.textLabel?.textColor = .clear
        self.addSubview(self.mainStack)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.text = self.textLabel?.text
        self.minLabel.text = " \(String(Int(self.slider.minimumValue))) %    "
        self.maxLabel.text = " \(String(Int(self.slider.maximumValue))) %"
    }
    
    
    func sliderValueDidChange(_ sender:UISlider!){
        self.valueLabel.text = "\(Int(sender.value)) % "
    }
    
    
    override func setCellData(key: String, value: AnyObject){
        if let v = value.floatValue {
            self.slider.value = v
            self.valueLabel.text = "\(Int(v)) % "
        }
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = Int(self.slider.value) as AnyObject
        return(key, value)
    }
    
    func getLabel()->UILabel{
        let l = UILabel()
        l.textAlignment = .center
        l.font =  UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }
}

open class SwitchCell:FormCell {
    
    lazy var switcher:UISwitch = {
        let s = UISwitch()
        s.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        return s
    }()
    
    func switchDidChange(_ sender:UISwitch!){
        
    }
    
    lazy var switchStack:UIStackView = {
         let s = UIStackView(frame: self.bounds)
        s.axis = .horizontal
        s.distribution = .fill
        s.alignment = .center
        s.spacing = 5
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(self.switcher)
        s.addArrangedSubview(self.space)
        return s
    }()

    
    override func setup() {
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        self.addSubview(self.switchStack)
    }
    
    override func setCellData(key: String, value: AnyObject){
            let boolValue = value as! Bool
            self.switcher.isOn = boolValue
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.switcher.isOn as AnyObject
        return(key, value)
    }
}

open class StepperCell:FormCell {
    
    lazy var stepper:UIStepper = {
        let s = UIStepper()
        s.addTarget(self, action: #selector(stepperDidChange(_:)), for: .valueChanged)
        return s
    }()
    
    lazy var valueLabel:UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    func stepperDidChange(_ sender:UIStepper!){
       self.valueLabel.text = "\(Int(sender.value))"
    }
    
    lazy var switchStack:UIStackView = {
        let s = UIStackView(frame: self.bounds)
        s.axis = .horizontal
        s.distribution = .fill
        s.alignment = .center
        s.spacing = 5
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(self.valueLabel)
        s.addArrangedSubview(self.stepper)
        s.addArrangedSubview(self.space)
        return s
    }()
    
    override func setup() {
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        self.addSubview(self.switchStack)
    }
    
    override func setCellData(key: String, value: AnyObject){
        let dblValue = value as! Double
        self.valueLabel.text = "\(Int(dblValue))"
        self.stepper.value = dblValue
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.stepper.value as AnyObject
        return(key, value)
    }
}

extension UIView{
    func addConstraintsWithFormat(_ format:String, views:UIView...){
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key]=view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: .alignAllLastBaseline, metrics: nil, views: viewsDictionary))
    }
}
