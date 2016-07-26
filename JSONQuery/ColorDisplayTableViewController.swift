//
//  ViewController.swift
//  JSONQuery
//
//  Created by Ryan Cortez on 7/25/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class ColorDisplayTableViewController: UITableViewController {
    
    var colors = [Color]()
    
    override func viewDidLoad() {
        pullJSON()
    }
    
    func pullJSON () {
        let urlAsString = "http://jsonplaceholder.typicode.com/photos"
        guard let url = NSURL(string: urlAsString) else {
            print("No url was created, \(urlAsString) was not a properly formatted URL"); return
        }
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            let colorArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            for item in colorArray {
                let color = Color(title: item.valueForKey("title") as! String, thumbnailURL: item.valueForKey("thumbnailUrl") as! String)
                self.colors.append(color)
            }
            dispatch_async(dispatch_get_main_queue(), {
                // this is the main/ui thread
                self.tableView.reloadData()
            })
            }.resume()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as? ColorCell else {
            print("Cell created was not a ColorCell, setting cell to blank UITableViewCell")
            let blankCell = UITableViewCell()
            return blankCell
        }
        let color = colors[indexPath.row]
        let title = color.title
        cell.label.text = title
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) {
            let imageURL = color.thumbnailURL
            guard let url = NSURL(string: imageURL) else {
                print("\(imageURL) is not a valid URL"); return
            }
            guard let data = NSData(contentsOfURL: url) else {
                print("Did not find image in URL"); return
            }
            cell.imageView?.image = UIImage(data: data)
        }
            
        return cell
    }

}

