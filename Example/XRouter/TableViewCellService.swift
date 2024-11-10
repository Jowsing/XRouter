//
//  TableViewCellService.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/9.
//

import UIKit
import Base

class MineMenuCellService: NSObject, TableViewCellService {
    
    var models: [[Any]] = [
        [
            "Payings",
            "Collects",
        ],
        [
            "Timelines",
            "Wallets",
            "Emojis",
        ],
        [
            "Settings",
        ],
    ]
    
    func getTableViewSections() -> [TableViewSection] {
        return models.map { rows in
            return TableViewSection(tableViewRows: rows.map({ row in
                return TableViewRow(cellType: MineMenuCell.self, model: row)
            }))
        }
    }
}
