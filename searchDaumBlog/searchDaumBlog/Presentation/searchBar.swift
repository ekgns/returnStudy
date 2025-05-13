//
//  searchBar.swift
//  searchDaumBlog
//
//  Created by 김다훈 on 5/13/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit


class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    // SearchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    
    // SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func bind() {
//        작동 시점
//        searchBar에 search Button이 탭 됐을 때
//        커스텀 버튼 탭 됐을 때
        Observable.merge(
            self.rx.searchButtonClicked.asObservable(),
            searchButton.rx.tap.asObservable()
        )
        .bind(to: searchButtonTapped)
        .disposed(by: disposeBag)
        
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        // 검색 버튼을 눌렀을 때
        self.shouldLoadResult = searchButtonTapped // 검색 버튼을 눌렀을 때
            // searchBar의 가장 최신 텍스트를 전달 if 텍스트가 없다면 빈값 내보내기
            .withLatestFrom(self.rx.text) { $1 ?? "" }
            .filter { !$0.isEmpty } // 빈값을 내보지지 않게 거른다
            .distinctUntilChanged() // 동일한 조건을 계속 보내 네트워크가 계속 통신되는걸 방지
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
            
        }
    }
}
