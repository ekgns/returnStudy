//
//  FilterViewModel.swift
//  searchDaumBlog
//
//  Created by 김다훈 on 5/14/25.
//

import Foundation
import RxSwift
import RxCocoa

struct FilterViewModel {
    // FilterView 외부에서 관촬
    let sortButtonTapped = PublishRelay<Void>()
}
