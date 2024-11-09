//
//  TableViewCellService.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import XRouter

struct TableViewRow {
    let cellType: UITableViewCell.Type
    let model: Any?
}

struct TableViewSection {
    let tableViewRows: [TableViewRow]
}

protocol TableViewCellService: RoutableService {
    func getTableViewSections() -> [TableViewSection]
}

extension TableViewCellService {
    static var name: String {
        return String(describing: self)
    }
}

class MineMenuCell: UITableViewCell {
    
}

class MineMenuCellService: NSObject, TableViewCellService {
    
    var models: [[Any]] = []
    
    func getTableViewSections() -> [TableViewSection] {
        return models.map { rows in
            return TableViewSection(tableViewRows: rows.map({ row in
                return TableViewRow(cellType: MineMenuCell.self, model: row)
            }))
        }
    }
}
