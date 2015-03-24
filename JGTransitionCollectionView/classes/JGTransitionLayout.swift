//
//  JGTransitionLayout.swift
//  JGTransitionCollectionView
//
//  Created by Jay on 24/03/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

import UIKit
import Foundation

class JGTransitionLayout: UICollectionViewLayout {
    
    var layoutAttributes : NSMutableDictionary = NSMutableDictionary()
    var itemSize : CGSize = CGSizeZero
    
    func commonInit(){
//self.itemSize = CGSizeMake(self.collectionView!.frame.size.width/2, self.collectionView!.frame.size.width/2)
        self.itemSize = CGSizeMake(320/2, 320/2)

    }
    
    override init() {
        super.init();
        self.commonInit();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareLayout() {
        var itemCount = self.collectionView?.numberOfItemsInSection(0);
        var layoutAttr = NSMutableDictionary();
        var y : CGFloat = 0
        var x : CGFloat = 0;
        for (var i = 0; i<itemCount; i++) {
            var indexPath = NSIndexPath(forItem: i, inSection: 0);
            var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            var frame : CGRect
            if (indexPath.row == 0) {
                x = 0;
                y = 0;
                frame = CGRectMake(x,  y, self.itemSize.width, self.itemSize.height);
                x += self.itemSize.width;
            }else if (indexPath.row % 2 == 0 ) {
                y += self.itemSize.height;
                x -= self.itemSize.width;
                frame = CGRectMake(x,  y, self.itemSize.width, self.itemSize.height);
                if (x <= 0) {
                    x += self.itemSize.width;
                }else{
                    x -= self.itemSize.width;
                }
            }else{
                frame = CGRectMake(x,  y, self.itemSize.width, self.itemSize.height);
                x += self.itemSize.width;
            }
            attributes.frame=frame;
            
            attributes.zIndex = i;
            layoutAttr[indexPath] = attributes;
        }
        layoutAttributes=layoutAttr;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttr = NSMutableArray();
        layoutAttributes.enumerateKeysAndObjectsUsingBlock { (indexPath, attributes, stop) -> Void in
            if (CGRectIntersectsRect(rect, attributes.frame)){
                layoutAttr.addObject(attributes)
            }
        }
        return layoutAttr;
    }
    
    override func collectionViewContentSize() -> CGSize {
        var itemCount = self.collectionView?.numberOfItemsInSection(0)
        var width = self.collectionView!.frame.size.width
        var height = self.itemSize.height * CGFloat(itemCount! / 2)
        return CGSizeMake(width, height);
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutAttributes[indexPath] as UICollectionViewLayoutAttributes
    }
    
}