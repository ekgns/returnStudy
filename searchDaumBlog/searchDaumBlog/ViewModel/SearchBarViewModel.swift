//
//  SearchBarViewModel.swift
//  searchDaumBlog
//
//  Created by 김다훈 on 5/14/25.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchBarViewModel {
    // SearchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    // SearchBar 외부로 내보낼 이벤트
    let shouldLoadResult: Observable<String>
    let queryText = PublishRelay<String?>()
    
    init () {
        // 검색 버튼을 눌렀을 때
        self.shouldLoadResult = searchButtonTapped // 검색 버튼을 눌렀을 때
        // searchBar의 가장 최신 텍스트를 전달 if 텍스트가 없다면 빈값 내보내기
            .withLatestFrom(self.queryText) { $1 ?? "" }
            .filter { !$0.isEmpty } // 빈값을 내보지지 않게 거른다
            .distinctUntilChanged() // 동일한 조건을 계속 보내 네트워크가 계속 통신되는걸 방지
    }
}
