//
//  addViewController.swift
//  SwiftTodo
//
//  Created by katoy on 2015/04/12.
//  Copyright (c) 2015年 Youichi Kato. All rights reserved.
//

import UIKit
import CoreData

class addViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myItemName: UITextField!
    @IBOutlet weak var myItemId: UITextField!

    @IBAction func btnAdd(sender: UIButton) {
        if do_create(myItemId.text) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func btnCancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func do_create(idStr: String?) -> Bool {
        if let str = idStr {
            if idStr == "" {
                myLabel.text = "Error: Please set id."
                return false
            }
            if idStr!.toInt() == nil {
                myLabel.text = "Error: id is not integer"
                return false
            }
            if find_by_int(idStr!.toInt()!) {
                myLabel.text = "Error: Already exist the id."
                return false
            }

            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if let managedObjectContext = appDelegate.managedObjectContext {
                let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Sample", inManagedObjectContext: managedObjectContext)
                let sample = managedObject as! SwiftTodo.Sample
                if let num = myItemId.text.toInt() {
                    sample.itemId = num
                    sample.itemName = myItemName.text
                    sample.itemTime = NSDate()
                    appDelegate.saveContext()
                }
            }
            return true
        }
        return false
    }
    // id :Int が存在するかを調べる。
    func find_by_int(id:Int) -> Bool {
        if id == 0 {
            myLabel.text = "Error: Please set id."
            return false
        }

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
