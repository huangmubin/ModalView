//
//  ModalView_Slider.swift
//  ModalView
//
//  Created by Myron on 2017/7/4.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

class ModalView_Slider: ModalView {
    
    // MARK: - Label
    
    var slider_label: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.text = "value"
        return label
    }()
    
    // MARK: - Slider
    
    var slider: UISlider = {
        let slider = UISlider()
        
        return slider
    }()
    
    func slider_action(_ sender: UISlider) {
        if datas.count > 0 {
            let space = 1 / Float(datas.count) / 2
            let move = Int((sender.value + space) * Float(datas.count - 1))
            //print("value = \(sender.value); space = \(space); move = \(move) count = \(datas.count);")
            index = move
            update_slider_label()
        }
        else {
            slider_label.text = String(format: "%.0f%%", sender.value * 100)
        }
    }
    
    func update_slider_label() {
        if index < datas.count {
            if let data = datas[index] as? String {
                slider_label.text = data
            }
            else {
                slider_label.text = "\(datas[index])"
            }
        }
    }
    
    // MARK: - Override
    
    override func deploy_at_init() {
        super.deploy_at_init()
        content_view.addSubview(slider_label)
        
        content_view.addSubview(slider)
        slider.addTarget(
            self,
            action: #selector(slider_action(_:)),
            for: UIControlEvents.valueChanged
        )
    }
    
    override func update_content_view_size(width: CGFloat) -> CGFloat {
        slider_label.sizeToFit()
        slider_label.frame = CGRect(
            x: 0, y: 0,
            width: width,
            height: slider_label.frame.height
        )
        
        slider.frame = CGRect(
            x: 0,
            y: slider_label.frame.maxY,
            width: width,
            height: 30
        )
        return slider.frame.maxY
    }
    
}
