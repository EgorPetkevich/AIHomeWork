//
//  OnbordingPageControl+Style.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import UIKit

extension UIPageControl {
    
    static func set(numOfPages: Int,
                    currentPage: Int) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numOfPages
        pageControl.currentPageIndicatorTintColor = .ActivityIndicator.currentDotColor
        pageControl.pageIndicatorTintColor = .ActivityIndicator.dotColor
        
        pageControl.updateDots(numOfPages: numOfPages,
                               currentPage: currentPage)
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }
    
    func updateDots(numOfPages: Int,
                    currentPage: Int) {
        for pageIndex in 0..<numOfPages {
            
            if pageIndex == currentPage {
                self.setIndicatorImage(.PageControlDots.currentDotImage, 
                                       forPage: pageIndex)
            } else if pageIndex < currentPage {
                self.setIndicatorImage(.PageControlDots.pastDotImage, 
                                       forPage: pageIndex)
            } else {
                self.setIndicatorImage(.PageControlDots.defaultDotImage, 
                                       forPage: pageIndex)
            }
        }
    }
    
}
