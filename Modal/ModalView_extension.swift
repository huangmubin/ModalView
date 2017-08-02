//
//  ModalView_extension.swift
//  ModalView
//
//  Created by Myron on 2017/7/4.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit



// MARK: - Extension

extension UIView {
    
    func modal(title: String, detail: String? = nil, action: @escaping (ModalView, UIButton, Any?) -> Void) {
        let model = ModalView()
        model.content_label.text = title
        model.content_label_detail.text = detail
        model.actions.append(action)
        model.display(to: self)
    }
    
    func modal(table title: String, detail: String? = nil, datas: [Any], index: Int, action: @escaping (ModalView, UIButton, Any?) -> Void) {
        let model = ModalView_TableView()
        model.content_label.text = title
        model.content_label_detail.text = detail
        model.datas = datas
        model.index = index
        model.actions.append(action)
        model.tableView.reloadData()
        model.display(to: self)
    }
    
    func modal(slider title: String, detail: String? = nil, datas: [Any], index: Int, action: @escaping (ModalView, UIButton, Any?) -> Void) {
        let model = ModalView_Slider()
        model.content_label.text = title
        model.content_label_detail.text = detail
        model.datas = datas
        model.index = index
        model.update_slider_label()
        model.actions.append(action)
        model.display(to: self)
    }
    
}
