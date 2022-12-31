//
//  DisplayTable.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 26/12/22.
//

import Foundation
import UIKit

class DisplayTable: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private lazy var tableDisplay: UITableView = {
        var table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 150.0
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
}

extension DisplayTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}
