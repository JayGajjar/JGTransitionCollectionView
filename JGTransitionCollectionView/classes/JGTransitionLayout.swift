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
        let screenSize = UIScreen.mainScreen().bounds.size
        self.itemSize = CGSizeMake(screenSize.width/2, screenSize.width/2)
    }
    
    override init() {
        super.init();
        self.commonInit();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override func prepareLayout() {
        let itemCount = self.collectionView?.numberOfItemsInSection(0);
        let layoutAttr = NSMutableDictionary();
        var y : CGFloat = 0
        var x : CGFloat = 0;
        for (var i = 0; i<itemCount; i += 1) {
            let indexPath = NSIndexPath(forItem: i, inSection: 0);
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
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
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttr = [UICollectionViewLayoutAttributes]();
        layoutAttributes.enumerateKeysAndObjectsUsingBlock { (indexPath, attributes, stop) -> Void in
            if (CGRectIntersectsRect(rect, attributes.frame)){
                layoutAttr.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        return layoutAttr
    }
    
    override func collectionViewContentSize() -> CGSize {
        let itemCount = self.collectionView?.numberOfItemsInSection(0)
        let width = self.collectionView!.frame.size.width
        let height = self.itemSize.height * CGFloat(itemCount! / 2)
        return CGSizeMake(width, height);
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath] as? UICollectionViewLayoutAttributes
    }
    
}