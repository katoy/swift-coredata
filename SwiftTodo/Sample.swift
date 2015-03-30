//
//  Sample.swift
//  SwiftTodo
//
//  Created by katoy on 2015/03/29.
//  Copyright (c) 2015年 Youichi Kato. All rights reserved.
//

import Foundation
import CoreData

class Sample: NSManagedObject {

    @NSManaged var itemId: NSNumber
    @NSManaged var itemName: String

}
