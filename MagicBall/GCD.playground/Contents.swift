import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// work item

var workItem: DispatchWorkItem!
workItem = DispatchWorkItem {
    while true {
        guard !workItem.isCancelled else { break }
        print(0)
    }
}

let backgroundQueue = DispatchQueue.global()
backgroundQueue.async(execute: workItem)
backgroundQueue.asyncAfter(deadline: .now() + 2.0) {
    workItem.cancel()
}

// deadlock

let serialQueue = DispatchQueue(label: "com.myApp.serialQueue")
let mainQueue = DispatchQueue.main

serialQueue.sync {
    print("These code will be executed")
    mainQueue.sync {
        print("Deadlock. This code wont't be executed")
    }
    print("Deadlock. This code wont't be executed")
}

