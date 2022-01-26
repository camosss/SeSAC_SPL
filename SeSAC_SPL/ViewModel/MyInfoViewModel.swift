//
//  MyInfoViewModel.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/26.
//

import Foundation
import RxCocoa

class MyInfoViewModel {
    var myinfos = BehaviorRelay<[MyInfo]>(value: [
        MyInfo(image: R.image.profileImg()!, item: "김새싹"),
        MyInfo(image: R.image.notice()!, item: "공지사항"),
        MyInfo(image: R.image.qna()!, item: "자주 묻는 질문"),
        MyInfo(image: R.image.faq()!, item: "1:1 문의"),
        MyInfo(image: R.image.settingAlarm()!, item: "알림 설정"),
        MyInfo(image: R.image.permit()!, item: "이용 약관")
    ])
}
