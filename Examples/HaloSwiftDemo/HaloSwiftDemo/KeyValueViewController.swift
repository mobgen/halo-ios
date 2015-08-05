//
//  KeyValueViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

class KeyValueViewController: UITableViewController {

    var values: [(String, String?)] = []
    private let cellIdent = "cellId"

    init(_ valueDict: Dictionary<String, AnyObject>?) {
        super.init(style: .Plain)

        if let dict = valueDict {
            for (k, v) in dict {
                values.append((k, String(v)))
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdent)
        }

        let tuple = values[indexPath.row]

        cell?.textLabel?.text = tuple.0
        cell?.detailTextLabel?.text = tuple.1

        return cell!

    }

}