//
//  TextCell.swift
//  TableForm
//
//  Created by Gazolla on 25/07/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit
import QuartzCore

open class TextCell: UITableViewCell, UITextFieldDelegate {
    
    var textField = UITextField()
    
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
}

open class NumberCell: UITableViewCell, UITextFieldDelegate {
    
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
        self.nf.delegate = self
        self.nf.tag = 3
        self.nf.translatesAutoresizingMaskIntoConstraints = false
        self.nf.placeholder = "0.00"
        //self.nf.font = UIFont.systemFont(ofSize: 35)
        //self.nf.borderStyle = UITextBorderStyle.roundedRect
        self.nf.autocorrectionType = UITextAutocorrectionType.no
        self.nf.keyboardType = UIKeyboardType.numberPad
        self.nf.returnKeyType = UIReturnKeyType.done
        self.nf.clearButtonMode = UITextFieldViewMode.whileEditing
        self.nf.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.nf.textAlignment = NSTextAlignment.right
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
    
}

open class IntCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        super.setup()
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
    }
}

open class PhoneCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        super.setup()
        textField.keyboardType = .phonePad
    }
}

open class NameCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.keyboardType = .asciiCapable
    }
}

open class EmailCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
    }
}

open class PasswordCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
    }
}

open class DecimalCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
    }
}

open class URLCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .URL
    }
}

open class TwitterCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .twitter
    }
}

open class AccountCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
    }
}

open class ZipCodeCell : TextCell {
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.keyboardType = .numbersAndPunctuation
    }
}

open class DateCell : TextCell {
    
    var datePicker = UIDatePicker()
    var formatter:DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
    
    required public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        super.setup()
        
        self.textField.textAlignment = .right
        self.textField.placeholder = formatter.string(from: Date())
        
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
    }
}

open class ButtonCell: UITableViewCell, UITextFieldDelegate {
    
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
    
    fileprivate func setup() {
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
