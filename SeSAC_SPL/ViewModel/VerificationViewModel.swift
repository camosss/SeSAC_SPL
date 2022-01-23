//
//  VerificationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/23.
//

import RxSwift
import RxCocoa

class VerificationViewModel: CommonViewModel {

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
    
    func transform(input: Input) -> Output {
        let result = input.text
            .orEmpty
//            .map { $0.count >= 10 && $0.count <= 11 }
            .map { $0.count > 2 }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
}
