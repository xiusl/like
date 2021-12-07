//
//  BaseViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var isPrefersHidden: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.isPrefersHidden, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        self.setupNavBar()
        
        tipView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        if #available(iOS 15, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.configureWithOpaqueBackground()
            barAppearance.backgroundColor = .white
            barAppearance.backgroundImage = UIImage(color: .white)
            barAppearance.shadowImage = UIImage()
            barAppearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = barAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func barButtonItem(_ title: String, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func showTipView() {
        showTipView(tip: "未知错误")
    }
    func showTipView(tip: String) {
        
    
        guard let window = UIApplication.shared.keyWindow else {return}
    
        if tipView.superview?.isDescendant(of: window) ?? false {
            return
        }
        window.addSubview(tipView)
        
        tipLabel.text = tip
        
        
        let st = UIApplication.shared.statusBarFrame.size.height + 6
        let sourceR = CGRect(x: ScreenWidth*0.5, y: st, width: 0, height: 0)
        tipView.frame = sourceR
        
        let frame = CGRect(x: 16, y: st, width: ScreenWidth-32, height: 32)
        
        
        UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseOut, animations: {
            self.tipView.frame = frame
            self.tipLabel.alpha = 1
        }) { (finished) in
            if finished {
                DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now()+1) {
                UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseIn, animations: {
                    self.tipView.frame = sourceR
                    self.tipLabel.alpha = 0
                }) { (finished) in
                    if finished {
                        self.tipView.removeFromSuperview()
                    }
                }
                }
            }
        }
    }
    
    lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xE64340)
        let st = UIApplication.shared.statusBarFrame.size.height
        view.frame = CGRect(x: 16, y: st, width: ScreenWidth-32, height: 0)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
}
