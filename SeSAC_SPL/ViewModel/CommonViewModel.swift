//
//  CommonViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import Foundation

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func phoneNumberTransform(input: Input) -> Output
    func certificationTransform(input: Input) -> Output
    func nickNameTransform(input: Input) -> Output
    func emailTransform(input: Input) -> Output
}
