//
//  NickNameViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa

class NickNameViewModel: CommonViewModel {
    
    var validText = BehaviorRelay<String>(value: "")

    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let validText: BehaviorRelay<String>
        let sceneTransition: ControlEvent<Void>
    }
    
    func nickNameTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isEmpty == false && $0.count <= 10 }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
}
