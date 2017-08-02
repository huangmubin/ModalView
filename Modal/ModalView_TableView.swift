//
//  ModalView_TableView.swift
//  ModalView
//
//  Created by Myron on 2017/7/3.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ModalView_TableView: ModalView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table Views
    
    var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.rowHeight = 30
        table.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "ModalView_TableView_Cell"
        )
        table.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        table.layer.cornerRadius = 10
        table.layer.borderWidth = 1
        return table
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(datas.count)")
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ModalView_TableView_Cell",
            for: indexPath
        )
        if let _ = cell.viewWithTag(10) as? UILabel { } else {
            let title = UILabel(frame: CGRect.zero)
            title.textAlignment = .center
            title.tag = 10
            cell.addSubview(title)
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let title = cell.viewWithTag(10) as? UILabel {
            title.frame = cell.bounds
            if let text = datas[indexPath.row] as? String {
                title.text = NSLocalizedString(text, comment: "")
            }
        }
        if indexPath.row == index {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            index = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // MARK: - Override
    
    override func deploy_at_init() {
        super.deploy_at_init()
        tableView.dataSource = self
        tableView.delegate = self
        content_view.addSubview(tableView)
    }
    
    override func update_content_view_size(width: CGFloat) -> CGFloat {
        print("update_content_view_size \(tableView.contentSize.height) \(tableView.bounds.height) \(datas) \(width)")
        tableView.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: min(tableView.contentSize.height, width)
        )
        return tableView.bounds.height
    }
}
