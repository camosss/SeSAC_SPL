//
//  OnboardingViewController.swift
//  SeSAC_SPL
//
//  Created by 강호성 on 2022/01/19.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slides = [
            OnboardingSlide(title: "위치 기반으로 빠르게\n주위 친구를 확인", image: UIImage(named: "1")!),
            OnboardingSlide(title: "관심사가 같은 친구를\n찾을 수 있어요", image: UIImage(named: "2")!),
            OnboardingSlide(title: "SeSAC Friends", image: UIImage(named: "3")!)
        ]
    }
    
    // MARK: - Action
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
