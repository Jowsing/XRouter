//
//  ViewController.swift
//  XRouter
//
//  Created by jowsing on 10/16/2024.
//  Copyright (c) 2024 jowsing. All rights reserved.
//

import UIKit
import X_Router
import Base

class MineViewController: UITableViewController {
    
    static let cellIdentifier = String(describing: MineMenuCell.self)
    
    var sections = [TableViewSection]()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mine"
        self.tableView = UITableView(frame: view.bounds, style: .grouped)
        self.tableView.register(MineMenuCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        self.tableView.rowHeight = 50
        // Do any additional setup after loading the view, typically from a nib.
        if let MineMenuCellService = Router.getServiceType(with: "MineMenuCellService") as? TableViewCellService.Type {
            self.sections = MineMenuCellService.init().getTableViewSections()
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableViewRows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        if let configCell = cell as? MineMenuCell {
            let row = sections[indexPath.section].tableViewRows[indexPath.row]
            configCell.setModel(row.model)
        }
        return cell
    }
}

extension MineViewController: RoutableController {
    func merge(parameters: Router.Parameters) {
        
    }
    
    static var paths: [String] {
        ["/mine"]
    }
    
    func update(parameters: Router.Parameters) {
        print("parameters ->", parameters)
    }
    
}

