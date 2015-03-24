//
//  JGTransitionCollectionView.swift
//  JGTransitionCollectionView
//
//  Created by Jay on 23/03/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

import Foundation
import UIKit

@objc protocol JGTransitionCollectionViewDatasource: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    optional func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
}

class JGTransitionCollectionView: UICollectionView,UICollectionViewDataSource {
    var jgDatasource : JGTransitionCollectionViewDatasource?
    var dataArray : NSMutableArray = NSMutableArray()
    var secondaryDataArray : NSMutableArray = NSMutableArray()
    
    private var animate : Bool = true
    
    // MARK: Initialisation
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.delegate = self
        self.dataSource = self
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.secondaryDataArray.count;
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = jgDatasource!.collectionView(self, cellForItemAtIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        if (indexPath.row < 7 && animate == true) {
            var progress = 0.0;
            var transform = CATransform3DIdentity;
            transform.m34 = -1.0/500.0;
            var angle = (1 - progress) * M_PI_2;
            if ((indexPath.row) % 4 == 3) {
                //left (perfect)
                self.setAnchorPoint(CGPointMake(1, 0.5), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 0, 1, 0  );
            }else if ((indexPath.row) % 4 == 2){
                //bottom followed by right
                self.setAnchorPoint(CGPointMake(0.5, 0), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 1, 0, 0  );
            }else if ((indexPath.row) % 4 == 1){
                //right (prtfect)
                self.setAnchorPoint(CGPointMake(0, 0.5), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(angle), 0, 1, 0  );
            }else if ((indexPath.row) % 4 == 0){
                //bottm
                self.setAnchorPoint(CGPointMake(0.5, 0), view: cell.contentView)
                transform = CATransform3DRotate(transform, CGFloat(-angle), 1, 0, 0  );
            }
            
            cell.contentView.layer.transform = transform;
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                cell.contentView.layer.transform = CATransform3DIdentity;
                }) { (finished) -> Void in
                    self.reloadDataWithTransition(indexPath);
            }
        }
        
        return cell;
    }
    
    
    func reloadDataWithTransition(indexPath : NSIndexPath) {
        
        if (indexPath.row < self.dataArray.count-1 && indexPath.row < 7 && self.animate == true) {
            
            self.secondaryDataArray.addObject(self.dataArray[(indexPath.row+1)]);
            self.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row+1, inSection: indexPath.section)])
            if indexPath.row == 6 {
                self.animate = false;
                self.secondaryDataArray = self.dataArray;
                self.reloadData()
            }else{
                self.animate = true
            }
        }else{
            self.animate = false;
            self.dataArray = self.secondaryDataArray;
        }
    }
    
    
    // MARK: HelperMethods
    func setAnchorPoint(anchorPoint : CGPoint,var view : UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
        
        var position = view.layer.position;
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    func setDataArray(array : NSArray){
        self.dataArray = array.mutableCopy() as NSMutableArray
        self.secondaryDataArray.addObject(array.firstObject!)
    }
    
    
}