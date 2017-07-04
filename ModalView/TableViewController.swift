//
//  TableViewController.swift
//  ModalView
//
//  Created by Myron on 2017/7/3.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            view.modal(
                title: "Modal",
                detail: "Modal detail.",
                action: { (modal, button, data) in
                    print("Modal select \(String(describing: data))")
            })
        case (1, 0):
            view.modal(
                table: "Table View Modal",
                detail: "Table view modal valus.",
                datas: [
                    "Value A",
                    "Value B",
                    "Value C",
                    "Value D",
                    "Value E",
                    "Value F",
                ],
                index: 0,
                action: { (modal, button, data) in
                    print("TableView select \(String(describing: data))")
            })
        case (2, 0):
            view.modal(
                slider: "Slider View Modal",
                detail: "Slider view modal valus.",
                datas: [CGFloat(0),0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
                index: 0,
                action: { (modal, button, data) in
                    print("SliderView select \(String(describing: data))")
            })
        default:
            break
        }
    }

}
