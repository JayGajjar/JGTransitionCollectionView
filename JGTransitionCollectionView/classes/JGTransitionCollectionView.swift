//
//  JGTransitionCollectionView.swift
//  JGTransitionCollectionView
//
//  Created by Jay on 23/03/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//


import Foundation
import UIKit

protocol JGTransitionCollectionViewDatasource: UICollectionViewDataSource {
    func collectionView(_ JGcollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ JGCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class JGTransitionCollectionView: UICollectionView,UICollectionViewDataSource {
    var jgDatasource : JGTransitionCollectionViewDatasource?
    var dataArray : NSMutableArray = NSMutableArray() {
        didSet {
            self.secondaryDataArray.add(dataArray.firstObject!)
            self.animate = true
        }
    }
    var secondaryDataArray : NSMutableArray = NSMutableArray()
    
    fileprivate var animate : Bool = true
    
    // MARK: Initialisation
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.delegate = self
        self.dataSource = self
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.secondaryDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = jgDatasource!.collectionView(self, cellForItemAt: indexPath)
        cell.backgroundColor = UIColor.clear
        if (indexPath.row == secondaryDataArray.count-1 && indexPath.row < 8 && animate == true) {
            self.animate = false
            
            let progress = 0.0
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/500.0
            let angle = (1 - progress) * Double.pi/2
            if ((indexPath.row) % 4 == 3) {
                //left (perfect)
                self.setAnchorPoint(CGPoint(x: 1, y: 0.5), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 0, 1, 0  )
            }else if ((indexPath.row) % 4 == 2){
                //bottom followed by right
                self.setAnchorPoint(CGPoint(x: 0.5, y: 0), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 1, 0, 0  )
            }else if ((indexPath.row) % 4 == 1){
                //right (prtfect)
                self.setAnchorPoint(CGPoint(x: 0, y: 0.5), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(angle), 0, 1, 0  )
            }else if ((indexPath.row) % 4 == 0){
                //bottm
                self.setAnchorPoint(CGPoint(x: 0.5, y: 0), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 1, 0, 0  )
            }
            
            cell.contentView.layer.transform = transform
            UIView.animate(withDuration: 0.5, animations: {
                cell.contentView.layer.transform = CATransform3DIdentity
            }, completion: { (finished) in
                cell.contentView.layer.transform = CATransform3DIdentity
                self.animate = true
                self.reloadDataWithTransition(indexPath)
            })
        }
        return cell
    }
    
    func reloadDataWithTransition(_ indexPath : IndexPath) {
        if (indexPath.row < self.dataArray.count-1 && indexPath.row < 8 && self.animate == true) {
            self.secondaryDataArray.add(self.dataArray[(indexPath.row+1)])
            //            self.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row+1, inSection: indexPath.section)])
            self.reloadData()
            if indexPath.row == 6 {
                self.animate = false
                self.secondaryDataArray = self.dataArray
                self.reloadData()
            }else{
                self.animate = true
            }
        }else{
            self.animate = false
            self.dataArray = self.secondaryDataArray
        }
    }
    
    
    // MARK: HelperMethods
    func setAnchorPoint(_ anchorPoint : CGPoint, view : UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y);
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y);
        
        newPoint = newPoint.applying(view.transform);
        oldPoint = oldPoint.applying(view.transform);
        
        var position = view.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
}
