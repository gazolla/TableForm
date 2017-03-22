# TableForm
Programmatically use of TableView to create data entry forms for iOS

![](https://github.com/gazolla/TableForm/raw/master/screenshot.png)

##Supported Platforms

- iOS 9
- swift 2.2

##Installing

In order to install, you'll need to copy the `FormViewController` and `FormCells` files into your Xcode project. 

##Usage

###create Fields:

```swift
        let name = Field(name:"name", title:"Nome:", cellType: NameCell.self)
        let birth = Field(name:"birthday", title:"Nascimento:", cellType: DateCell.self)
        let address = Field(name:"address", title:"Address:", cellType: TextCell.self)
```

###add Fields to Section:

```swift
        let sectionPersonal = [name, address, birth]
```

###group all Sections:

```swift
        let sections = [sectionPersonal, sectionProfessional, sectionButton]
```


###call ConfigureTable:

```swift
let config = ConfigureForm(items: sections) { (tableView, indexPath) in
            let cell = tableView.tableView.cellForRowAtIndexPath(indexPath)
            if cell is ButtonCell {
                cell?.selected = false
                let dic = tableView.getFormData()
                print(dic)
            }
  }
```

###Set the configuration to TableViewController:
```swift
        let main = FormViewController(config: config)
```

### Contact

* Sebastian Gazolla Jr
* [@gazollajr](http://twitter.com/gazollajr)
* [http://about.me/gazolla](http://about.me/gazolla)

##License

`TableForm` is licensed under the MIT license.
