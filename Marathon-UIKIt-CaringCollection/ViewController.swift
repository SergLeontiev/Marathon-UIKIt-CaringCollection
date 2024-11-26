//
//  ViewController.swift
//  Marathon-UIKIt-CaringCollection
//
//  Created by Sergey Leontiev on 25.11.24..
//

import UIKit

class ViewController: UIViewController {
    private let colors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemTeal,
        .systemOrange, .systemPink, .systemCyan, .systemFill, .systemMint, .systemBrown
    ]
    private lazy var collectionView: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row].withAlphaComponent(0.8)
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout else { return }
        
        let cellWidth = layout.itemSize.width + layout.spacing
        
        let index: CGFloat = {
            let estimatedIndex = targetContentOffset.pointee.x / cellWidth
            if velocity.x > 0 {
                return ceil(estimatedIndex)
            } else if velocity.x < 0 {
                return floor(estimatedIndex)
            } else {
               return round(estimatedIndex)
            }
        }()
        
        let newOffset = index * cellWidth - collectionView.layoutMargins.left
        targetContentOffset.pointee = CGPoint(x: max(newOffset, 0), y: targetContentOffset.pointee.y)
    }
}
