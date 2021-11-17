//
//  MainPageViewController.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 16/11/21.
//

import UIKit

class MainPageViewController : UIPageViewController{
    
    // MARK: - UI Elements
    private var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard(name: "OnboardingScene", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "step1")
        let secondVC = storyboard.instantiateViewController(withIdentifier: "step2")
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "step3")
        return [firstVC, secondVC, thirdVC]
    }()
    
    // MARK: - Properties
    //private var currentIndex = 0
    private var pageControl = UIPageControl()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        layout()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        self.setViewControllers([viewControllerList[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func pushNext() {
//        if currentIndex + 1 < viewControllerList.count {
//            self.setViewControllers([self.viewControllerList[self.currentIndex + 1]], direction: .forward, animated: true, completion: nil)
//            currentIndex += 1
//        }
    }
    
    func layout() {
            view.addSubview(pageControl)
            
            NSLayoutConstraint.activate([
                pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
                pageControl.heightAnchor.constraint(equalToConstant: 25),
                view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
            ])
        }
    
}

extension MainPageViewController {
    
    // How we change page when pageControl tapped.
    // Note - Can only skip ahead on page at a time.
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([viewControllerList[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

extension MainPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllerList.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentIndex
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let current = viewControllerList.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = current
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //let dataViewController = viewController as DataVi
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil
        }
        return viewControllerList[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        if currentIndex == viewControllerList.count-1 {
            return nil
        }
        return viewControllerList[currentIndex + 1]
    }
    
    
}
