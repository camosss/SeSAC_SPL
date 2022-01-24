//
//  ValidationViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/24.
//

import RxSwift
import RxCocoa

class ValidationViewModel: CommonViewModel {

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
    
    func phoneNumberTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isValidPhoneNumber() }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
    func certificationTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isVaildVerificationCode() }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
    func nickNameTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isEmpty == false && $0.count <= 10 }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
    func emailTransform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isVaildEmail() }
            .share(replay: 1, scope: .whileConnected)
        return Output(validStatus: result, validText: validText, sceneTransition: input.tap)
    }
    
}
