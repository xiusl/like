//
//  HomeViewModel.swift
//  Like
//
//  Created by duoji on 2020/10/30.
//  Copyright © 2020 likeeee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class HomeViewModel: UIView {

    public enum HomeErro {
        
    }
    
    public let articles: PublishSubject<[Article]> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    public func requestData() {
        ApiManager.shared.request(request: ArticleApiRequest.getArticles(page: 1, count: 10)) { (result) in
            let data = JSON(result)
            var tmpAritcles: Array<Article> = data["articles"].arrayValue.compactMap({ return Article(fromJson: $0)})
            self.articles.onNext(tmpAritcles)
        } failed: { (error) in
            
        }
    }
}
