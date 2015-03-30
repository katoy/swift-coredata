//
//  ViewController.swift
//  SwiftTodo
//
//  Created by katoy on 2015/03/29.
//  Copyright (c) 2015年 Youichi Kato. All rights reserved.
//
// See http://daifuku-p.org/w/?p=485
//       SWIFTでCOREDATAを使う[CREATE編]
//     http://daifuku-p.org/w/?p=502
//       SWIFTでCOREDATAを使う[CREATE編２]
//     http://daifuku-p.org/w/?p=529
//       SWIFTでCOREDATAを使う[SELECT編]


import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myItemName: UITextField!
    @IBOutlet weak var myItemId: UITextField!
    @IBAction func create(sender: UIButton) {
        myLabel.text = ""
        if insertData() {
            myLabel.text = "created!"
        }
    }
    @IBAction func read(sender: UIButton) {
        myLabel.text = ""
        if let name = readData() {
            myItemName.text = name
            myLabel.text = name
            myLabel.text = "readed!"
        }

    }
    @IBAction func update(sender: UIButton) {
        myLabel.text = ""
        if updateData() {
            println("itemId:\(myItemId.text) itemName:\(myItemName.text)")
             myLabel.text = "updated!"
        }
    }
    @IBAction func deleteX(sender: AnyObject) {
        myLabel.text = ""
        if deleteData() {
            myLabel.text = "deleted!"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func find(id:Int) -> Bool {
        if id == 0 {
            myLabel.text = "Error: Please set id."
            return false
        }

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Sample", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;

            let predicate = NSPredicate(format: "%K = %d", "itemId", id)
            fetchRequest.predicate = predicate
            var error: NSError? = nil;
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                if results.count > 0 {
                    return true
                }
            }
        }
        return false
    }

    func find(idStr:String) -> Bool {
        if idStr == "" {
            myLabel.text = "Error: Please set id."
            return false
        }
        return find(idStr.toInt()!)
    }

    func insertData() -> Bool {
        if myItemId.text == "" {
            myLabel.text = "Error: Please set id."
            return false
        }
        if find(myItemId.text) {
            myLabel.text = "Error: Already exist the id."
            return false
        }

        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Sample", inManagedObjectContext: managedObjectContext)
            let sample = managedObject as SwiftTodo.Sample
            sample.itemId = myItemId.text.toInt()!
            sample.itemName = myItemName.text
            appDelegate.saveContext()
        }
        return true
    }

    func readData() -> String? {
        if myItemId.text == "" {
            myLabel.text = "Error: Please set id."
            return nil
        }
        if !find(myItemId.text) {
            myLabel.text = "Error: Not found id."
            return nil
        }
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Sample", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;

            let predicate = NSPredicate(format: "%K = %d", "itemId", myItemId.text.toInt()!)
            fetchRequest.predicate = predicate

            var error: NSError? = nil;
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let sample = managedObject as Sample;
                    return sample.itemName
                }
            }
        }
        return nil
    }

    func updateData() -> Bool {
        if myItemId.text == "" {
            myLabel.text = "Error: Please set id."
            return false
        }
        if !find(myItemId.text) {
            myLabel.text = "Error: Not found id."
            return false
        }
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Sample", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            let predicate = NSPredicate(format: "%K = %d", "itemId", myItemId.text.toInt()!)
            fetchRequest.predicate = predicate

            var error: NSError? = nil;
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let sample = managedObject as Sample;
                    sample.itemName = myItemName.text
                }
            }
            appDelegate.saveContext()
        }
        return true
    }

    func deleteData() -> Bool {
        if myItemId.text == "" {
            myLabel.text = "Error: Please set id."
            return false
        }
        if !find(myItemId.text) {
            myLabel.text = "Error: Not found id."
            return false
        }
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Sample", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;

            let predicate = NSPredicate(format: "%K = %d", "itemId", myItemId.text.toInt()!)
            fetchRequest.predicate = predicate

            var error: NSError? = nil;
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let sample = managedObject as Sample;
                    managedObjectContext.deleteObject(sample)
                    return true
                }
            }
        }
        return false
    }
}

