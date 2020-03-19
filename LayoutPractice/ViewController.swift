//
//  ViewController.swift
//  LayoutPractice
//
//  Created by Ryan on 2020/3/18.
//  Copyright © 2020 Hanyu. All rights reserved.
//

import UIKit
import Parchment

class ViewController: UIViewController {
  
  let height: CGFloat = 100
  lazy var topConstrant = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: containerView.topAnchor)
  lazy var containerView = makeContainerView()
  lazy var emptyView = makeEmptyView(height: height)
  lazy var pagingViewController = makePagingViewController()
  
  override func loadView() {
    super.loadView()
    
    addChild(pagingViewController)
    pagingViewController.didMove(toParent: self)
    view.addSubview(containerView)
    
    NSLayoutConstraint.activate([
      topConstrant,
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    view.backgroundColor = .gray
    
    pagingViewController.dataSource = self //重要，不能讓 pagingViewController 的 tableView 先執行 scrollViewDelegate，會導致嚴重的 crash
  }
}

extension ViewController {
  func makeContainerView() -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: [emptyView, pagingViewController.view])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    return stackView
  }
  func makeEmptyView(height:CGFloat) -> UIView {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .red
    view.heightAnchor.constraint(equalToConstant: height).isActive = true
    return view
  }
  func makePagingViewController() -> PagingViewController {
    let vc = PagingViewController()
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    vc.menuBackgroundColor = .blue
    vc.textColor = .blue
    vc.selectedTextColor = .blue
    vc.indicatorColor = .blue
    vc.font = .boldSystemFont(ofSize: 15)
    vc.selectedFont = .boldSystemFont(ofSize: 15)
    vc.borderColor = .blue
    vc.indicatorOptions = .visible(height: 3, zIndex: .max, spacing: .zero, insets: .zero)
    vc.borderOptions = .visible(height: 1, zIndex: .max, insets: .zero)
    return vc
  }
}

extension ViewController: PagingViewControllerDataSource {
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return 10
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    let vc = TableViewController(numberOfRows: (index + 10) * 4)
    vc.view.backgroundColor = .green
    vc.tableView.delegate = self
    //    vc.tableView.bounces = false //加了就不會有負的 offset，會造成無法滑動
    return vc
  }
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: "\(index)")
  }
}

extension ViewController: UITableViewDelegate {
  
}

extension ViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard isViewLoaded else {
      return
    }
    
    let offsetY = scrollView.contentOffset.y
    let newConstant = topConstrant.constant + offsetY
    let theConstant = (0...height).clapping(for: newConstant)
    topConstrant.constant = theConstant
  }
}

extension ClosedRange {
  func clapping(for value: Bound) -> Bound {
    return Swift.min(upperBound,Swift.max(value,lowerBound))
  }
}
