//
//  EmojiInputView.swift
//  Like
//
//  Created by szhd on 2021/12/23.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

class EmojiInputView: UIView {

    var didSelectedEmoji: ((_ emoji: String) -> ())?
    var didDeletedEmoji: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var emojiArray: Array<String> = []
    
    private func setupViews() {
        var resourcePath = Bundle.main.resourcePath!
        resourcePath.append("/Emoj.plist")
        if let arr = NSArray(contentsOfFile: resourcePath) {
            for str in arr {
                emojiArray.append(str as! String)
            }
        }
        
        addSubview(collectionView)
        addSubview(deleteBtn)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomMargin())
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
    }
    @objc
    func deleteBtnClickAction() {
        didDeletedEmoji?()
    }

    private lazy var collectionView: UICollectionView = {
        let layout = EmojiInputViewLayout()
        let w = (ScreenWidth-16)/8
        layout.itemSize = CGSize(width: w, height: w)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8);
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell_id")
        return view
    }()
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(deleteBtnClickAction), for: .touchUpInside)
        return btn
    }()
}

extension EmojiInputView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiArray.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell_id", for: indexPath)
        var label = cell.contentView.viewWithTag(101) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = 101
            label?.font = .systemFont(ofSize: 32)
            cell.contentView.addSubview(label!)
            label?.textAlignment = .center
            label?.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
        
        label?.text = emojiArray[indexPath.row]
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedEmoji?(emojiArray[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}


class EmojiInputViewLayout : UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attrs = super.layoutAttributesForElements(in: rect) {
            for attr in attrs {
                
                // ScreenWidth - 16 - 9
                let f = collectionView?.contentOffset.y ?? 0
                let x = ScreenWidth - 16 - (ScreenWidth/8) * 2 - 1
                if attr.frame.origin.x > x && (attr.frame.origin.y - f) > 230 {
                    print(f, x, attr.frame.origin.y - f)
                    attr.alpha = 0
                    if let cell = collectionView?.cellForItem(at: attr.indexPath) {
                        cell.alpha = 0
                    }
                    
                } else {
                    attr.alpha = 1
                    if let cell = collectionView?.cellForItem(at: attr.indexPath) {
                        cell.alpha = 1
                    }
                }
            }
            return attrs
        }
        return []
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("indexPath =>", indexPath)
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        print("indexPath =>", indexPath, " position =>", position)
        return super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
    }
}
