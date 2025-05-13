//
//  AlertActionConvertible.swift
//  searchDaumBlog
//
//  Created by 김다훈 on 5/13/25.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
