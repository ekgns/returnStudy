//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by 김다훈 on 5/16/25.
//

import Foundation
import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    let disposeBag = DisposeBag()
    
    // viewModel = > View
    let showFreeSahreButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishSubject<Void>()
    
    init() {
        self.showFreeSahreButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" },
                freeShareButtonTapped.map{ _ in false}
            )
            .asSignal(onErrorJustReturn: false)
        
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}

