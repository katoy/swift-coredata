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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myItemName: UITextField!
    @IBOutlet weak var myItemId: UITextField!
    @IBAction func create(sender: UIButton) {
        myLabel.text = ""
        if insertData() {
            myLabel.text = "created!"
            tableView.reloadData()
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
            tableView.reloadData()
        }
    }
    @IBAction func deleteX(sender: AnyObject) {
        myLabel.text = ""
        if deleteData() {
            myLabel.text = "deleted!"
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // See  http://d.hatena.ne.jp/aoki_p/20141127/1417100836
        //     > Core Dataで作成されたSQLiteファイルの場所を確認する
        // ===== AppDelegateのpersistentStoreCoodinator属性を評価する =====
        let coodinator = (UIApplication.sharedApplication().delegate as AppDelegate).persistentStoreCoordinator
        println(coodinator)
        // =============================================================

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // セルに表示する情報を得る。
    var sampleData = [Sample]()

    func fetchData() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Sample")
            // itemTime の降順でソートする
            let sortDescriptor = NSSortDescriptor(key: "itemTime", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Sample] {
                sampleData = fetchResults
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // セルの行数を返す
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchData()
        return sampleData.count
    }

    // セルの表示内容を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        fetchData()
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let s = sampleData[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row):  \(s.itemId) = \(s.itemName)"
        cell.detailTextLabel?.text = "\(s.itemTime)"
        return cell
    }

    // Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        let s = sampleData[indexPath.row]
        // println("Value: \(s.itemId) = \(s.itemName)")
        // 選択したセルの内容をテキストエリアに転送する。
        myItemId.text   = "\(s.itemId)"
        myItemName.text = s.itemName
    }

    // itemId :Int が存在するかを調べる。
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
    // itemId :String が存在するかを調べる。
    func find(idStr:String) -> Bool {
        if idStr == "" {
            myLabel.text = "Error: Please set id."
            return false
        }
        return find(idStr.toInt()!)
    }

    // id, name を新規追加する。
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
            sample.itemTime = NSDate()
            appDelegate.saveContext()
        }
        return true
    }

    // itemId から itemName を得る。
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

    // itemId の itemName を変更する
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
                    sample.itemTime = NSDate()
                }
            }
            appDelegate.saveContext()
        }
        return true
    }

    // itemId を削除する。
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
