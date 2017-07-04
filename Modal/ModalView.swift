//
//  ModalView.swift
//  ModalView
//
//  Created by Myron on 2017/7/3.
//  Copyright © 2017年 Myron. All rights reserved.
//

import UIKit

// MARK: - Modal Bulid

protocol ModalView_Bulid_Delegate: class {
    func modal_deploy(modal: ModalView)
}

class ModalView_Bulid {
    static let `default` = ModalView_Bulid()
    weak var delegate: ModalView_Bulid_Delegate?
    private init() { }
    func deploy(modal: ModalView) {
        delegate?.modal_deploy(modal: modal)
    }
}

// MARK: - Protocol

protocol ModalView_Delegate_Protocol: class {
    func modal(view: ModalView, action button: UIButton, data: Any?)
}

// MARK: - Modal View

class ModalView: UIView {
    
    // MARK: Override Data
    
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size {
                layout_contents()
            }
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                layout_contents()
            }
        }
    }
    
    // MARK: - Content Views
    
    /**  */
    var background_view: UIView = UIView()
    var content_label: UILabel = UILabel()
    var content_label_detail: UILabel = UILabel()
    var content_view: UIView = UIView()
    var content_buttons: [UIButton] = {
        var buttons = [UIButton]()
        let button_1 = UIButton(type: UIButtonType.system)
        button_1.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        buttons.append(button_1)
        let button_2 = UIButton(type: UIButtonType.system)
        button_2.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        buttons.append(button_2)
        return buttons
    }()

    // MARK: Other views
    
    var line_view_horizontal: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    var line_view_verticals: [UIView] = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return [view]
    }()
    
    
    // MARK: - View Datas
    
    /** Content view width multiplier to superview, is 0 ~ 1 */
    var content_view_width: CGFloat = 0.5
    
    weak var delegate: ModalView_Delegate_Protocol?
    
    var datas: [Any] = []
    
    var index: Int = 0
    
    // MARK: - Init
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        deploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        deploy()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func deploy() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        // Notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientation),
            name: .UIApplicationDidChangeStatusBarOrientation,
            object: nil
        )
        
        // Deploy
        deploy_at_init()
        layout_contents()
    }
    
    /** Deploy action at init. */
    func deploy_at_init() {
        // Content View
        addSubview(background_view)
        background_view.backgroundColor = UIColor.white
        background_view.layer.cornerRadius = 20
        background_view.layer.shadowRadius = 2
        background_view.layer.shadowOffset = CGSize.zero
        background_view.layer.shadowOpacity = 1
        
        background_view.addSubview(content_label)
        //content_label.text = "Modal"
        content_label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 4)
        
        background_view.addSubview(content_label_detail)
        content_label_detail.textColor = UIColor.lightGray
        //content_label_detail.text = "Modal view label text is detail.Modal view label text is detail.Modal view label text is detail.Modal view label text is detail."
        content_label_detail.numberOfLines = 0
        
        background_view.addSubview(content_view)
        
        for (i, button) in content_buttons.enumerated() {
            button.tag = i + 100
            background_view.addSubview(button)
            button.addTarget(self, action: #selector(button_actions(_:)), for: .touchUpInside)
        }
        
        background_view.addSubview(line_view_horizontal)
        for line in line_view_verticals {
            background_view.addSubview(line)
        }
    }
    
    // MARK: Orientation
    
    /** Orientaion notification action. */
    func orientation() {
        DispatchQueue.main.async { [weak self] in
            if let view = self?.superview {
                UIView.animate(withDuration: 0.25, animations: {
                    self?.frame = view.bounds
                })
            }
        }
    }
    
    // MARK: - Display and Dismiss
    
    /** Display popups view to view. */
    func display(to: UIView) {
        // Deploy and append to superview.
        self.frame = to.bounds
        self.layout_contents(to.bounds.width)
        
        ModalView_Bulid.default.deploy(modal: self)
        
        self.alpha = 0
        to.addSubview(self)
        
        //
        let frame = self.background_view.frame
        for sub in self.background_view.subviews {
            sub.alpha = 0
        }
        self.background_view.frame = CGRect(
            x: bounds.width / 2,
            y: bounds.height / 2,
            width: 0,
            height: 0
        )
        
        if let scroll = to as? UIScrollView {
            scroll.isScrollEnabled = false
        }
        
        //
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }, completion: { _ in
            self.display_completion()
        })
        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 60, options: UIViewAnimationOptions.curveLinear, animations: {
            self.background_view.frame = frame
        }, completion: { _ in
            for sub in self.background_view.subviews {
                sub.alpha = 1
            }
        })
    }
    
    /** dismiss from superview */
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            if let scroll = self.superview as? UIScrollView {
                scroll.isScrollEnabled = true
            }
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Layout
    
    /** update the sub view layout */
    func layout_contents(_ super_width: CGFloat = 0) {
        var width: CGFloat    = (self.superview?.bounds.width ?? super_width) * content_view_width
        width = min(width, min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) / 2)
        let center_x: CGFloat = width / 2
        var frame_y: CGFloat  = 20
        
        // label
        content_label.sizeToFit()
        content_label.center = CGPoint(
            x: center_x,
            y: content_label.bounds.height / 2 + frame_y
        )
        frame_y = frame_y + content_label.bounds.height + 10
        
        // detail label
        if content_label_detail.text?.isEmpty == false {
            content_label_detail.frame = CGRect(x: 0, y: 0, width: width - 40, height: 100000)
            content_label_detail.sizeToFit()
            content_label_detail.center = CGPoint(
                x: center_x,
                y: content_label_detail.bounds.height / 2 + frame_y
            )
            frame_y = frame_y + content_label_detail.bounds.height + 10
        }
        
        // content view
        let content_heigh = update_content_view_size(width: width - 40)
        if content_heigh != 0 {
            content_view.frame = CGRect(
                x: 20,
                y: frame_y,
                width: width - 40,
                height: content_heigh
            )
            frame_y = frame_y + content_heigh + 10
        }
        
        // line
        line_view_horizontal.frame = CGRect(
            x: 0,
            y: frame_y,
            width: width,
            height: 1
        )
        frame_y += 1
        
        // buttons
        let button_width = width / CGFloat(content_buttons.count)
        for (i, button) in content_buttons.enumerated() {
            button.frame = CGRect(
                x: button_width * CGFloat(i),
                y: frame_y,
                width: button_width,
                height: 50
            )
        }
        
        // buttons space line
        for (i, line) in line_view_verticals.enumerated() {
            line.frame = CGRect(
                x: CGFloat(i + 1) * button_width - 0.5,
                y: frame_y,
                width: 1,
                height: 50
            )
        }
        frame_y += 50
        
        // background view
        background_view.frame = CGRect(
            x: (bounds.width - width) / 2,
            y: (bounds.height - frame_y) / 2,
            width: width,
            height: frame_y
        )
    }
    
    // MARK: - Button Actions
    
    var actions: [(ModalView, UIButton, Any?) -> Void] = []
    
    func button_actions(_ sender: UIButton) {
        let tag = sender.tag - 101
        switch tag {
        case -1:
            break
        default:
            let data: Any? = datas.count > index ? datas[index] : nil
            if tag < actions.count {
                actions[tag](self, sender, data)
            }
            delegate?.modal(
                view: self,
                action: sender,
                data: data
            )
        }
        actions.removeAll()
        self.dismiss()
    }
    
    // MARK: - Subview override.
    
    /** update the content view frame and return the height. */
    func update_content_view_size(width: CGFloat) -> CGFloat { return 0 }
    
    /** Call when display. */
    func display_completion() { }
    
    /** Update datas */
    func update(data: Any) { }
    
    
    
}
