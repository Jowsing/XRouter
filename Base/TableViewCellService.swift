//
//  TableViewCellService.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import X_Router

public struct TableViewRow {
    public let cellType: UITableViewCell.Type
    public let model: Any?
    
    public init(cellType: UITableViewCell.Type, model: Any?) {
        self.cellType = cellType
        self.model = model
    }
}

public struct TableViewSection {
    public let tableViewRows: [TableViewRow]
    
    public init(tableViewRows: [TableViewRow]) {
        self.tableViewRows = tableViewRows
    }
}

public protocol TableViewCellService: RoutableService {
    func getTableViewSections() -> [TableViewSection]
}

public extension TableViewCellService {
    static var name: String {
        return String(describing: self)
    }
}

public class MineMenuCell: UITableViewCell {
    
    public func setModel(_ model: Any?) {
        if let text = model as? String {
            self.textLabel?.text = text
        }
    }
}
