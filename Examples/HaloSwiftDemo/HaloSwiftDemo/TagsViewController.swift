//
//  TagsViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 27/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import Halo

class TagsViewController: UITableViewController {

    var tags: [Halo.UserTag] = []
    let cellIdent = "cellIdent"
    let mgr = Halo.Manager.sharedInstance
    let alertController = UIAlertController(title: "Add tag", message: nil, preferredStyle: .Alert)

    init() {
        super.init(style: .Plain)

        loadTags()

        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Tag name"
        }

        alertController.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "Tag value (optional)"
        }

        alertController.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let name = self.alertController.textFields![0] as UITextField
            let value = self.alertController.textFields![1] as UITextField

            let tag = Halo.UserTag(name: name.text!, value: value.text)

            self.mgr.user?.tags?.insert(tag)
            self.mgr.saveUser(completionHandler: { _ in

                self.loadTags()
                self.tableView.reloadData()
            })

        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in

        }))

    }

    private func loadTags() {
        if let tags = mgr.user?.tags {
            self.tags = tags.flatMap({ (tag) -> Halo.UserTag? in
                return tag
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAddTagPopup:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdent)
        }

        let tag = tags[indexPath.row]

        cell?.textLabel?.text = tag.name
        cell?.detailTextLabel?.text = tag.value
        
        return cell!
        
    }

    func showAddTagPopup(sender: AnyObject?) {
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}