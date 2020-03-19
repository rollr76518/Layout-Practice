//
//  TableViewController.swift
//  LayoutPractice
//
//  Created by Ryan on 2020/3/18.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	let numberOfRows: Int
	
	init(numberOfRows: Int) {
		self.numberOfRows = numberOfRows
		super.init(style: .plain)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = "\(indexPath)"
		return cell
	}
}
