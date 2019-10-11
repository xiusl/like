//
//  ProgressHUD.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/23.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit

public enum ProgressHUDAnimation: Int {
    case fade
    case zoom
    case zoomIn
    case zoomOut
}

public enum ProgressHUDMode: Int {
    case indeterminate
    case determinate
    case determinateHorizontalBar
    case annularDeterminate
    case customView
    case text
}

public enum ProgressHUDBackgroundStyle: Int {
    case solidColor
    case blur
}

class ProgressHUD: UIView {
    open var graceTime: TimeInterval = 0.0
    open var minShowTime: TimeInterval = 0.0
    open var removeFromSuperViewOnHide: Bool = false
    open var mode: ProgressHUDMode = .indeterminate
    
    open var animationType: ProgressHUDAnimation = .fade
    
    open var contentColor: UIColor?
    open var offset: CGPoint = CGPoint.zero
    open var margin: CGFloat = 20.0
    open var minSize: CGSize = CGSize(width: 0, height: 0)
    open var isSquare: Bool = false
    open var progress: Float = 0.0
    open var progressObject: Progress?
    
    private(set) lazy var bezelView: ProgressHUDBackgroundView = {
        let bezelView = ProgressHUDBackgroundView()
        return bezelView
    }()
    private(set) lazy var backgroundView: ProgressHUDBackgroundView = {
        let backgroundView = ProgressHUDBackgroundView()
        return backgroundView
    }()
    
    open var customView: UIView?
    
    private(set) var label: UILabel = {
        let label = UILabel()
        return label
    }()
    private(set) var detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        return detailsLabel
    }()
    private(set) var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var topSpacer: UIView = {
        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.isHidden = true
        return topSpacer
    }()
    private var bottomSpacer: UIView = {
        let bottomSpacer = UIView()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.isHidden = true
        return bottomSpacer
    }()

    
    var useAnimation: Bool = false
    var didFinished: Bool = false
    
    
    private weak var graceTimer: Timer?
    private weak var minShowTimer: Timer?
    private weak var hideDelayTimer: Timer?
    
    private var showStarted: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }
    
   
    func commonInit() {
        animationType = .fade
        mode = .indeterminate
        margin = 20
        
        contentColor = UIColor(white: 0, alpha: 0.7)
        self.isOpaque = false
        self.backgroundColor = .clear
        self.alpha = 0
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.layer.allowsGroupOpacity = false
        
        self.setupViews()
        
        self.setNeedsUpdateConstraints()
    }
    /*
     - (void)commonInit {
   
     [self setupViews];
     [self updateIndicators];
     [self registerForNotifications];
     }
     */
    private func setupViews() {
        let defaultColor = self.contentColor
        
        self.backgroundView.frame = self.bounds
        self.backgroundView.style = .solidColor
        self.backgroundView.backgroundColor = .clear
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.alpha = 0;
        self.addSubview(self.backgroundView)
        
        self.bezelView.translatesAutoresizingMaskIntoConstraints = false
        self.bezelView.layer.cornerRadius = 5
        self.bezelView.alpha = 0;
        self.addSubview(self.bezelView)
        
        self.label.adjustsFontSizeToFitWidth = false
        self.label.textAlignment = .center
        self.label.textColor = defaultColor
        self.label.font = UIFont.systemFont(ofSize: 14)
        self.label.isOpaque = false
        self.label.backgroundColor = .clear
        
        self.detailsLabel.adjustsFontSizeToFitWidth = false
        self.detailsLabel.textAlignment = .center
        self.detailsLabel.textColor = defaultColor
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.font = UIFont.systemFontBold(ofSize: 14)
        self.detailsLabel.isOpaque = false
        self.detailsLabel.backgroundColor = .clear
        
        for view in [self.label, self.detailsLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998), for: .horizontal)
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998), for: .vertical)
            self.bezelView.addSubview(view)
        }
        
        self.bezelView.addSubview(self.topSpacer)
        self.bezelView.addSubview(self.bottomSpacer)
    }
    
    open class func showHUD(toView view: UIView, animated: Bool) -> ProgressHUD {
        let hud = ProgressHUD(view: view)
        view.addSubview(hud)
        hud.showAnimated(animated: true)
        return hud
    }
    
    open func showAnimated(animated: Bool) {
        self.useAnimation = animated
        self.didFinished = false
        if self.graceTime > 0.0 {
            let timer = Timer(timeInterval: self.graceTime, target: self, selector: #selector(handleGraceTimer(_:)), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
            self.graceTimer = timer
        } else {
            self.showUsingAnimation(animation: self.useAnimation)
        }
    }
    func showUsingAnimation(animation: Bool) {
        self.bezelView.layer.removeAllAnimations()
        self.backgroundView.layer.removeAllAnimations()
        
        self.hideDelayTimer?.invalidate()
        
        self.showStarted = Date()
        self.alpha = 1
        
        if animation {
            self.animate(animateIn: true, withType: self.animationType, complation: nil)
        }
    }
    
    
    /*
     - (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
     NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
     [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
     self.hideDelayTimer = timer;
     }

     */
    open func hide(animated: Bool, afterDelay delay: TimeInterval) {
        let timer = Timer(timeInterval: delay, target: self, selector: #selector(handleHideTimer(_ :)), userInfo: animated, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.hideDelayTimer = timer
    }
    
    
    func hide(animated: Bool) {
        self.minShowTimer?.invalidate()
        self.useAnimation = animated
        self.hasFinished = true
        if self.minShowTime > 0.0 && self.showStarted != nil {
            let interv = NSDate().timeIntervalSince(self.showStarted!)
            if interv < self.minShowTime {
                let timer = Timer(timeInterval: (self.minShowTime-interv), target: self, selector: #selector(handleMinShowTimer(_:)), userInfo: nil, repeats: false)
                RunLoop.current.add(timer, forMode: .common)
                self.minShowTimer = timer
            }
        }
        self.hideUsingAnimation(self.useAnimation)
    }
    
    private var hasFinished: Bool = false
    func done() {
        self.hideDelayTimer?.invalidate()
        if self.hasFinished {
            self.alpha = 0
            if self.removeFromSuperViewOnHide {
                self.removeFromSuperview()
            }
        }
    }
    func hideUsingAnimation(_ animated: Bool) {
        if animated && self.showStarted != nil {
            self.showStarted = nil
            self.animate(animateIn: false, withType: self.animationType) { (finished) in
                self.done()
            }
        } else {
            self.showStarted = nil
            self.bezelView.alpha = 0
            self.backgroundView.alpha = 0
            self.done()
        }
    }
    
    func animate(animateIn: Bool, withType type: ProgressHUDAnimation, complation: ((Bool) -> Void)?) {
        var tType = type
        if type == .zoom {
            tType = animateIn ? .zoomIn : .zoomOut
        }
        
        let small = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let large = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        let bezelView = self.bezelView
        if animateIn && bezelView.alpha == 0 && tType == .zoomIn {
            bezelView.transform = small
        } else if animateIn && bezelView.alpha == 0 && tType == .zoomOut {
            bezelView.transform = large
        }
        
        let animations: () -> Void = {
            if animateIn {
                bezelView.transform = CGAffineTransform.identity
            } else if !animateIn && tType == .zoomIn {
                bezelView.transform = large
            } else if !animateIn && tType == .zoomOut {
                bezelView.transform = small
            }
            let alpha: CGFloat = animateIn ? 1.0 : 0.0
            bezelView.alpha = alpha
            self.backgroundView.alpha = alpha
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: animations, completion: complation)
    }
    
    @objc private func handleGraceTimer(_ timer: Timer) {
        
    }
    @objc private func handleHideTimer(_ timer: Timer) {
        self.hide(animated: timer.userInfo as! Bool)
    }
    @objc private func handleMinShowTimer(_ timer: Timer) {
        self.hideUsingAnimation(self.useAnimation)
    }

    var bezelConstraints: Array<NSLayoutConstraint>?
    override func updateConstraints() {
        let bezel = self.bezelView
        let topSpacer = self.topSpacer
        let bottomSpacer = self.bottomSpacer
        
        let margin = self.margin
        
        var bezelConstraints: Array<NSLayoutConstraint> = Array()
        
        let subViews = [self.topSpacer, self.label, self.detailsLabel, self.bottomSpacer]
        
        self.removeConstraints(self.constraints)
        topSpacer.removeConstraints(topSpacer.constraints)
        bottomSpacer.removeConstraints(bottomSpacer.constraints)
        if self.bezelConstraints != nil {
            bezel.removeConstraints(self.bezelConstraints!)
            self.bezelConstraints = nil
        }

        let offset = self.offset
        var centeringConstraints: Array<NSLayoutConstraint> = Array()
        centeringConstraints.append(NSLayoutConstraint(item: bezel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: offset.x))
        centeringConstraints.append(NSLayoutConstraint(item: bezel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: offset.y))
        self.apply(priority: UILayoutPriority(rawValue: 998), toConstraints: centeringConstraints)
        self.addConstraints(centeringConstraints)
        
        let metrics = ["margin":margin]
        
        var sideConstraints: Array<NSLayoutConstraint> = Array()
        sideConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[bezel]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["bezel":bezel]))
        sideConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=margin)-[bezel]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["bezel":bezel]))
        self.apply(priority: UILayoutPriority(rawValue: 999), toConstraints: sideConstraints)
        self.addConstraints(sideConstraints)
        
        let minimumSize = self.minSize
        if minimumSize != CGSize.zero {
            var minSizeConstraints: Array<NSLayoutConstraint> = Array()
            minSizeConstraints.append(NSLayoutConstraint(item: bezel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: minimumSize.width))
            minSizeConstraints.append(NSLayoutConstraint(item: bezel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: minimumSize.height))
            self.apply(priority: UILayoutPriority(rawValue: 997), toConstraints: minSizeConstraints)
            bezelConstraints.append(contentsOf: minSizeConstraints)
        }
        
        if self.isSquare {
            let square = NSLayoutConstraint(item: bezel, attribute: .height, relatedBy: .equal, toItem: bezel, attribute: .height, multiplier: 1, constant: 1)
            square.priority = UILayoutPriority(rawValue: 997)
            bezelConstraints.append(square)
        }
        
        topSpacer.addConstraint(NSLayoutConstraint(item: topSpacer, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: margin))
        bottomSpacer.addConstraint(NSLayoutConstraint(item: bottomSpacer, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: margin))
        
        bezelConstraints.append(NSLayoutConstraint(item: topSpacer, attribute: .height, relatedBy: .equal, toItem: bottomSpacer, attribute: .height, multiplier: 1, constant: 0))
        
        var paddingConstraints: Array<NSLayoutConstraint> = Array()
        for (idx, view) in subViews.enumerated() {
            bezelConstraints.append(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: bezel, attribute: .centerX, multiplier: 1, constant: 0))
            bezelConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[view]-(>=margin)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: ["view":view]))
            if idx == 0 {
                bezelConstraints.append(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: bezel, attribute: .top, multiplier: 1, constant: 0))
            } else if idx + 1 == subViews.count {
                bezelConstraints.append(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bezel, attribute: .bottom, multiplier: 1, constant: 0))
            }
            
            if idx > 0 {
                let padding = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: subViews[idx - 1], attribute: .bottom, multiplier: 1, constant: 0)
                bezelConstraints.append(padding)
                paddingConstraints.append(padding)
            }
        }
        
        bezel.addConstraints(bezelConstraints)
        self.bezelConstraints = bezelConstraints
        self.paddingConstraints = paddingConstraints
        self.updatePaddingConstraints()
        super.updateConstraints()
    }
    var paddingConstraints: Array<NSLayoutConstraint> = Array()
    func updatePaddingConstraints() {
        var hasVisibleAncestors = false
        for (_, constraint) in self.paddingConstraints.enumerated() {
            let firstView = constraint.firstItem
            let secondView = constraint.secondItem
            let firstVisible = !(firstView?.isHidden ?? false) && firstView?.intrinsicContentSize == CGSize.zero
            let secondVisible = !(secondView?.isHidden ?? false) && secondView?.intrinsicContentSize == CGSize.zero
            constraint.constant = (firstVisible && (secondVisible || hasVisibleAncestors)) ? 8 : 0
            hasVisibleAncestors = hasVisibleAncestors || secondVisible
        }
    }
    /*
     - (void)applyPriority:(UILayoutPriority)priority toConstraints:(NSArray *)constraints {
     for (NSLayoutConstraint *constraint in constraints) {
     constraint.priority = priority;
     }
     }
     */
    private func apply(priority: UILayoutPriority, toConstraints constraints: Array<NSLayoutConstraint>) {
        for constraint in constraints {
            constraint.priority = priority
        }
    }
}


class ProgressHUDBackgroundView: UIView {
    open var style: ProgressHUDBackgroundStyle = .blur {
        didSet {
            self.updateForBackgroundStyle()
        }
    }
    open var color: UIColor? {
        didSet {
            self.updateForBackgroundStyle()
        }
    }
    
    private var effectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style = .blur
        color =  UIColor(white: 0.8, alpha: 0.6)
        self.clipsToBounds = true
        self.updateForBackgroundStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize.zero
        }
    }
    
    private func updateForBackgroundStyle() {
        self.effectView?.removeFromSuperview()
        self.effectView = nil
        
        let style = self.style
        if style == .blur {
            let effect = UIBlurEffect(style: .light)
            let effectView = UIVisualEffectView(effect: effect)
            self.addSubview(effectView)
            effectView.frame = self.bounds
            effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.backgroundColor = self.color
            self.layer.allowsGroupOpacity = false
            self.effectView = effectView
        } else {
            self.backgroundColor = self.color;
        }
    }
    
}
