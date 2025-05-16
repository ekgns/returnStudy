//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by 김다훈 on 5/16/25.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    
    // View -> ViewModel
    let contentValue = PublishRelay<String?>()
    
}
