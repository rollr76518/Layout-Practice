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

	lazy var scrollView = makeScrollView()
	lazy var containerView = makeContainerView()
	lazy var emptyView = makeEmptyView()
	lazy var pagingViewController = makePagingViewController()
	
	override func loadView() {
		super.loadView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(scrollView)
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
			pagingViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -pagingViewController.menuItemSize.height) //TODO: 這個高度有點問題
		])
		
		view.backgroundColor = .gray
		
		pagingViewController.dataSource = self //重要，不能讓 pagingViewController 的 tableView 先執行 scrollViewDelegate，會導致嚴重的 crash
	}
}

extension ViewController {
	
	func makeScrollView() -> UIScrollView {
		let view = UIScrollView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		view.addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: view.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
		return view
	}
	
	func makeContainerView() -> UIStackView {
    addChild(pagingViewController)
		let stackView = UIStackView(arrangedSubviews: [emptyView, pagingViewController.view])
    pagingViewController.didMove(toParent: self)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		return stackView
	}
	
	func makeEmptyView() -> UIView {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .red
		view.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
//		vc.tableView.bounces = false //加了就不會有負的 offset，會造成無法滑動
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
		let frame = self.scrollView.convert(pagingViewController.view.frame, to: containerView)

		print("scrollView.contentOffset.y:\(scrollView.contentOffset.y)")
		print("self.scrollView.contentOffset.y:\(self.scrollView.contentOffset.y)")

		if scrollView.isKind(of: UITableView.self) {
			if scrollView.contentOffset.y <= 0 && self.scrollView.contentOffset.y > 0 { //向下拉
				let offsetY = self.scrollView.contentOffset.y + scrollView.contentOffset.y
				self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: offsetY)
				scrollView.contentOffset = .zero
			} else if self.scrollView.contentOffset.y < frame.minY { //向上推
				let offsetY = self.scrollView.contentOffset.y + scrollView.contentOffset.y
				self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: max(offsetY, 0))
				scrollView.contentOffset = .zero
			}
		} else if scrollView == self.scrollView {
			let minY = min(frame.minY, scrollView.contentOffset.y)
			scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minY)
		}
	}
}
