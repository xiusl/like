//
//  AppAboutViewController.swift
//  Like
//
//  Created by xiu on 2020/4/18.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class AppAboutViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.logoView)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.versionLabel)
        self.view.addSubview(self.privacyButton)
        self.view.addSubview(self.copyLabel)
        
        let info = Bundle.main.infoDictionary!
        let name = info["CFBundleDisplayName"] as! String
        self.nameLabel.text = name.localized
        
        let version = info["CFBundleShortVersionString"]
        self.versionLabel.text = String(format: "Version %@", version as! String)

        #if DEBUG
            let build = info["CFBundleVersion"]
            self.versionLabel.text = String(format: "Version %@(%@)", version as! String, build as! String)
        #else
        #endif
        
        
        let format = DateFormatter()
        format.dateFormat = "YYYY"
        let year = format.string(from: Date())
        self.copyLabel.text = "Copyright © \(year) xiusl."
        
        self.logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(48)
            make.size.equalTo(64)
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoView.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }
        self.versionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(2)
            make.centerX.equalTo(self.view)
        }
        self.privacyButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-80);
            make.centerX.equalTo(self.view)
        }
        self.copyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.privacyButton.snp.bottom).offset(4)
            make.centerX.equalTo(self.view)
        }
    }
    
    @objc private func privacyButtonAction() {
        let vc = WebViewController()
        vc.url = "https://ins.sleen.top/privacy"
        vc.title = "隐私政策"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.layer.cornerRadius = 8
        logoView.image = UIImage(named: "logo")
        logoView.clipsToBounds = true
        return logoView
    }()

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .black;
        return nameLabel
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    lazy var privacyButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("User Privacy Policy".localized, for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.addTarget(self, action: #selector(privacyButtonAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var copyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .c999999
        return label
    }()
}
