//
//  JGTransitionLayout.swift
//  JGTransitionCollectionView
//
//  Created by Jay on 24/03/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

import UIKit
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class JGTransitionLayout: UICollectionViewLayout {
    
    var layoutAttributes : NSMutableDictionary = NSMutableDictionary()
    var itemSize : CGSize = CGSize.zero
    
    func commonInit(){
        let screenSize = UIScreen.main.bounds.size
        self.itemSize = CGSize(width: screenSize.width/2 , height: screenSize.width/2)
    }
    
    override init() {
        super.init();
        self.commonInit();
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override func prepare() {
        let itemCount = self.collectionView?.numberOfItems(inSection: 0);
        let layoutAttr = NSMutableDictionary();
        var y : CGFloat = 0
        var x : CGFloat = 0;
        
        for i in 0..<itemCount! {
            let indexPath = IndexPath(item: i, section: 0);
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            var frame : CGRect
            if (indexPath.row == 0) {
                x = 0;
                y = 0;
                frame = CGRect(x: x,  y: y, width: self.itemSize.width, height: self.itemSize.height);
                x += self.itemSize.width;
            }else if (indexPath.row % 2 == 0 ) {
                y += self.itemSize.height;
                x -= self.itemSize.width;
                frame = CGRect(x: x,  y: y, width: self.itemSize.width, height: self.itemSize.height);
                if (x <= 0) {
                    x += self.itemSize.width;
                }else{
                    x -= self.itemSize.width;
                }
            }else{
                frame = CGRect(x: x,  y: y, width: self.itemSize.width, height: self.itemSize.height);
                x += self.itemSize.width;
            }
            attributes.frame=frame;
            
            attributes.zIndex = i;
            layoutAttr[indexPath] = attributes;
        }
        layoutAttributes=layoutAttr;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttr = [UICollectionViewLayoutAttributes]();
        layoutAttributes.enumerateKeysAndObjects({ (indexPath, attributes, stop) -> Void in
            let attributes = attributes as! UICollectionViewLayoutAttributes
            if (rect.intersects(attributes.frame)){
                layoutAttr.append(attributes)
            }
        })
        return layoutAttr
    }
    
    override var collectionViewContentSize : CGSize {
        let itemCount = self.collectionView?.numberOfItems(inSection: 0)
        let width = self.collectionView!.frame.size.width
        let height = self.itemSize.height * CGFloat(itemCount! / 2)
        return CGSize(width: width, height: height);
    }
    
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath] as? UICollectionViewLayoutAttributes
    }
}
