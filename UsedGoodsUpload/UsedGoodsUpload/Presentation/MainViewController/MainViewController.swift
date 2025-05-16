//
//  MainViewController.swift
//  UsedGoodsUpload
//
//  Created by 김다훈 on 5/16/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        
    }
    
    private func attribute() {
        title = "중고거래 글쓰기"
        view.backgroundColor = .black
        
        submitButton.title = "제출"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextFieldCell") // index row 0
        
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

typealias Alert = (title: String, message: String?)

extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base , data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil )
            
            alertController.addAction(action)
            base.present(alertController, animated: true, completion: nil)
        }
    }
}
