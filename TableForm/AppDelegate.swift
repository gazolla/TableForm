//
//  AppDelegate.swift
//  TableForm
//
//  Created by Gazolla on 25/07/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func createFieldsAndSections()->[[Field]]{
        let name = Field(name: "name:", cellType: NameCell.self)
        let address = Field(name: "address:", cellType: TextCell.self)
        let birth = Field(name: "birthday:", cellType: DateCell.self)
        let sectionPersonal = [name, address, birth]
        
        let company = Field(name: "company:", cellType: NameCell.self)
        let position = Field(name: "position:", cellType: TextCell.self)
        let salary = Field(name: "salary:", cellType: NumberCell.self)
        let sectionProfessional = [company, position, salary]
        
        let save = Field(name: "Save", cellType: ButtonCell.self)
        let sectionButton = [save]
        
        return [sectionPersonal, sectionProfessional, sectionButton]
    }
    
    func createConfigureTableStruct(formItems:[[Field]])->ConfigureTable{
        
        return ConfigureTable(items: formItems, configureCell: { (cell, field) in
            
            }) { (form, indexPath) in
                let cell = form.tableView.cellForRow(at: indexPath as IndexPath)
                if cell is ButtonCell {
                    cell?.isSelected = false
                    let dic = form.getFormData()
                    print(dic)
                }
        }
        
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let sections = self.createFieldsAndSections()
        
        let config = self.createConfigureTableStruct(formItems: sections)
        
        let myForm = FormViewController(config:config)
        myForm.title = "Form"
        
        let nav = UINavigationController(rootViewController: myForm)
        self.window!.rootViewController = nav
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

