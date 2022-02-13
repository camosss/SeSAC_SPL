//
//  SearchDetailViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/02/13.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var requests: SearchFriendRequest?
    
    let viewModel = SearchDetailViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchFriend()
    }
    
    // MARK: - Helper
    
    // 새로고침 버튼에도 적용
    private func searchFriend() {
        guard let requests = requests else { return }

        viewModel.searchFriend(region: requests.region, lat: requests.lat, long: requests.long) { friends, error, statusCode in
            if let friends = friends {
                print("[SearchDetail] friends", friends.fromQueueDB.count)
                // 빈 화면(1_3_near_user_empty & 1_4_accept_empty): 취미 함께 하기를 할 수 있는 다른 사용자가 없는 경우
                // 주변 새싹 화면 & 받은 요청 화면(1_3_near_user & 1_4_accept): 취미 함께 하기를 할 수 있는 다른 사용자가 있는 경우
            }
        }
    }
    
//    5초마다 서버 호출을 통해 사용자(본인)의 상태 확인
    
//    성공(200)
//    만약 응답이 성공(200)하고 응답값 중 matched 가 1이라면, 사용자(본인) 현재 상태를 매칭된 상태로 변경합니다.
//    “000님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다” 토스트 메시지를 1초 간 띄운 뒤, 채팅 화면(1_5_chatting)으로 이동합니다.
    
//    201: 취미를 함께 하기 위해 새싹 친구를 찾는 시간이 오래 되어 찾기중단으로 처리된 경우입니다.
//    “오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다”는 토스트 메시지를 1초간 띄웁니다.
//    사용자(본인)의 현재 상태를 일반 상태로 변경한 뒤, 홈 화면으로 화면을 전환합니다.
    
    
}
