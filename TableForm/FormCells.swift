//
//  TextCell.swift
//  TableForm
//
//  Created by Gazolla on 05/10/17.
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
    
    func setup() {
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        self.textLabel?.textColor = .black
    }
    
    func setCellData(key: String, value: AnyObject){  }
    
    func getCellData()-> (key: String, value: AnyObject){
        let key = ""
        let value = "" as AnyObject
        return(key, value)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.tag == 999 { //botton cell
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2.0)
            layer.shadowRadius = 2.0
            layer.shadowOpacity = 1.0
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        }
    }

}

open class TextViewCell: FormCell, UITextViewDelegate {
    
    var textView = UITextView()
    
    override func setup() {
        super.setup()
        
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        self.textView.delegate = self
        self.textView.tag = 3
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textView)
        
        addConstraintsWithFormat("V:|-3-[v0]-3-|", views:self.textView)
        addConstraintsWithFormat("H:|-100-[v0]-5-|", views:self.textView)
        
        self.textView.textAlignment = .left
    }
    
    override  open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.becomeFirstResponder()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    override func setCellData(key: String, value: AnyObject){
        self.textView.text! = value as! String
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.textView.text as AnyObject
        return(key, value)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        let tableView =  view as? UITableView
        
        let txtFieldPosition =  textView.convert(textView.bounds.origin, to: tableView)
        let indexPath =  tableView?.indexPathForRow(at: txtFieldPosition)
        if indexPath != nil {
            tableView?.scrollToRow(at: indexPath!, at: .top, animated: true)
        }
        return true
    }
}

open class ImageCell: FormCell, UITextViewDelegate {
    
    var imgView = UIImageView()
    var fileName:String = ""
    
    override func setup() {
        super.setup()
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        imgView.backgroundColor = .white
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imgView)
        
        addConstraintsWithFormat("V:|-3-[v0]-3-|", views:self.imgView)
        addConstraintsWithFormat("H:|-100-[v0]-5-|", views:self.imgView)
    }
    
    
    override func setCellData(key: String, value: AnyObject){
        fileName = value as! String
        imgView.image = UIImage(named: fileName)
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = fileName as AnyObject
        return(key, value)
    }
    
}

open class TextCell: FormCell, UITextFieldDelegate {
    
    var textField:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.tag = 3
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .left
        tf.contentVerticalAlignment = .center
        return tf
    }()
    
    override func setup() {
        super.setup()
        contentView.viewWithTag(3)?.removeFromSuperview()
        textField.delegate = self
        addSubview(textField)
        
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-5).isActive = true
        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant:115).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    override  open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.becomeFirstResponder()
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
        
    override func setCellData(key: String, value: AnyObject){
        if let strValue = value as? String {
            self.textField.text! = strValue
        }
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.textField.text as AnyObject
        return(key, value)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        let tableView =  view as? UITableView
        
        let txtFieldPosition =  textField.convert(textField.bounds.origin, to: tableView)
        let indexPath =  tableView?.indexPathForRow(at: txtFieldPosition)
        if indexPath != nil {
            tableView?.scrollToRow(at: indexPath!, at: .top, animated: true)
        }
        return true
    }
    
    
}

open class NumberCell: FormCell, UITextFieldDelegate {
    
    lazy var numberFormatted:UITextField = {
        let nf = UITextField()
        nf.delegate = self
        nf.tag = 3
        nf.translatesAutoresizingMaskIntoConstraints = false
        nf.placeholder = "0.00"
        nf.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        nf.autocorrectionType = UITextAutocorrectionType.no
        nf.keyboardType = UIKeyboardType.numberPad
        nf.returnKeyType = UIReturnKeyType.done
        nf.clearButtonMode = UITextFieldViewMode.whileEditing
        nf.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        nf.textAlignment = NSTextAlignment.center
        return nf
    }()
    
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
        super.setup()
        self.addSubview(numberFormatted)
        
        numberFormatted.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        numberFormatted.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-5).isActive = true
        numberFormatted.leftAnchor.constraint(equalTo: self.leftAnchor, constant:115).isActive = true
        numberFormatted.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    override  open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberFormatted.becomeFirstResponder()
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    print("amountTypedString:\(amountTypedString)")
        if string.count > 0 {
            print(string)
            amountTypedString += string
            print(amountTypedString)
            let decNumber = NSDecimalNumber(value: Float(amountTypedString)! as Float).multiplying(by: 0.01)
            print(decNumber)
            let newString = formatter.string(from: decNumber)!
            print(newString)
            numberFormatted.text = newString
        } else {
            amountTypedString = String(amountTypedString.dropLast())
            if amountTypedString.count > 0 {
                let decNumber = NSDecimalNumber(value: Float(amountTypedString)! as Float).multiplying(by: 0.01)
                let newString = formatter.string(from: decNumber)!
                numberFormatted.text = newString
            } else {
                numberFormatted.text = "0.00"
            }
            
        }
        return false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        amountTypedString = ""
        return true
    }
    
    override func setCellData(key: String, value: AnyObject){
        var strValue = ""
        if value is String{
            strValue = value as! String
        } else if value is Double {
            strValue = String(format: "%\(0.2)f", (value as! Double))
            // strValue = "\(value)"
        }
        numberFormatted.text! = strValue
        let charsNotToBeTrimmed = (0...9).map{String($0)}
        for i in strValue{
            if !charsNotToBeTrimmed.contains(String(i)){
                strValue = strValue.replacingOccurrences(of: String(i), with: "")
            }
        }
  //      print("filtered: \(strValue)")
        amountTypedString = strValue
  //      print("amountTypedString:\(amountTypedString)")
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = numberFormatted.text as AnyObject
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
    
    override open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        self.textField.text = formatter.string(from: sender.date)
        // self.update?(sender.date)
    }
    
    override func setCellData(key: String, value: AnyObject){
        if let dateValue = value as? Date {
            self.datePicker.date = dateValue
            self.textField.text! = self.formatter.string(from: dateValue)
        }
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = self.textField.text as AnyObject
        return(key, value)
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
        textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    }
}


open class LinkCell : FormCell {
    
    lazy var valueLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.baselineAdjustment = .alignCenters
        l.textAlignment = .right
        l.font =  UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:.value1, reuseIdentifier: reuseIdentifier)
        self.setup()
        textLabel?.textColor = .black
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override  open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func setup() {
        super.setup()
        accessoryType = .disclosureIndicator
        editingAccessoryType =  .none
        addSubview(valueLabel)
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        let margins = self.layoutMarginsGuide
        valueLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: margins.rightAnchor, constant:-40).isActive = true
        valueLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5).isActive = true
    }
  
    open override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = ""
    }
    
    override func setCellData(key: String, value: AnyObject){
        if let strValue = value as? String {
            valueLabel.text = strValue
        }
    }
    
    override func getCellData()-> (key: String, value: AnyObject){
        let key = self.name!
        let value = valueLabel.text as AnyObject
        return(key, value)
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
    
    
    @objc func sliderValueDidChange(_ sender:UISlider!){
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
    
    @objc func switchDidChange(_ sender:UISwitch!){
        
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
    
    @objc func stepperDidChange(_ sender:UIStepper!){
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
        if let dblValue = value.int64Value {
            self.valueLabel.text = "\(Int(dblValue))"
            self.stepper.value = Double(dblValue)
        }
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

