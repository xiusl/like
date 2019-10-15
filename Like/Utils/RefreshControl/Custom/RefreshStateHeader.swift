//
//  RefreshStateHeader.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshStateHeader: RefreshHeader {

    
    open lazy var lastUpdatedTimeLabel: UILabel = {
        let lastUpdatedTimeLabel = UILabel.mjLabel()
        return lastUpdatedTimeLabel
    }()
    
    var labelLeftInset: CGFloat = 0
    
    lazy var stateLabel: UILabel = {
       let stateLabel = UILabel.mjLabel()
        return stateLabel
    }()
    
    
    var stateTitles: [RefreshState:String] = [:]
    /** 设置state状态下的文字 */
    open func set(title: String, forState state: RefreshState) {
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state];
    }
    
    
    override func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        if self.lastUpdatedTimeLabel.superview == nil {
            self.addSubview(self.lastUpdatedTimeLabel)
        }
        
        self.labelLeftInset = 25
        
        self.set(title: "下拉可以刷新", forState: .idle)
        self.set(title: "松开立即刷新", forState: .pulling)
        self.set(title: "正在刷新数据中...", forState: .refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.stateLabel.isHidden { return }
        
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0
        
        if self.lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = self.bounds
            }
        } else {
            let stateLabelH = self.frame.size.height * 0.5
            
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: stateLabelH)
            }
            
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                self.lastUpdatedTimeLabel.frame = CGRect(x: 0, y: stateLabelH, width: self.frame.size.width, height: self.frame.size.height-stateLabelH)
            }
        }
    }
    
    override func setState(_ state: RefreshState) {
         
         let oldState = self.state
         if oldState == state {return}
         super.setState(state)
         self.state = state
    
         self.stateLabel.text = self.stateTitles[state];
        
        self.setupLastUpdatedTimeKey()
    }
    func setupLastUpdatedTimeKey() {
        if self.lastUpdatedTimeLabel.isHidden { return }
        
        let lastUpdatedTime = UserDefaults.standard.value(forKey: self.lastUpdatedTimeKey) as? Date
        
//        if self.lastUpdatedTimeText {
//
//        }
        
        if lastUpdatedTime != nil {
            let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
            let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute]
            let cmp1 = calendar?.components(unitFlags, from: lastUpdatedTime!)
            let cmp2 = calendar?.components(unitFlags, from: Date())
            
            let formatter = DateFormatter()
            var isToday = false
            if cmp1?.day == cmp2?.day {
                formatter.dateFormat = " HH:mm"
                isToday = true
            } else if cmp1?.year == cmp2?.year {
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            
            let time = formatter.string(from: lastUpdatedTime!)
            self.lastUpdatedTimeLabel.text = String(format: "最后更新：%@%@", (isToday ? "今天" : ""), time)
            
        } else {
            self.lastUpdatedTimeLabel.text = "最后更新：无记录"
        }
    }
}
