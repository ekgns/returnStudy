//
//  MainViewModel.swift
//  searchDaumBlog
//
//  Created by 김다훈 on 5/14/25.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 네트워크를 통해 가져온 값을 cell Data로 변환
        let cellData = blogValue
            .compactMap(model.getBlogListCellData)
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때의 sortedType
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // MainViewController -> ListView로 전달
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort
            )
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSortiong = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "앗",
                    message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도해 주세요.\(message)",
                    actions: [.confirm],
                    style: .alert)
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSortiong,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
