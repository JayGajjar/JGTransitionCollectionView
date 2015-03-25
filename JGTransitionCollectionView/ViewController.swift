//
//  ViewController.swift
//  JGTransitionCollectionView
//
//  Created by Jay on 23/03/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

import UIKit

class ViewController: UIViewController , JGTransitionCollectionViewDatasource {

    @IBOutlet weak var collView: JGTransitionCollectionView!
    var dataSource : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadData()
        self.collView.setDataArray(self.dataSource)
        self.collView.jgDatasource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: JGCustomCell  = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as JGCustomCell;
        var dataDict = self.dataSource.objectAtIndex(indexPath.row) as NSDictionary
        cell.contentView.backgroundColor = dataDict["color"] as? UIColor
        cell.backgroundImage.image = UIImage(named: NSString(format: "car%d", indexPath.row+1))
        return cell;
    }
    
    //MARK : Helpers
    func loadData(){
        self.dataSource = NSMutableArray()
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#3F1A3B"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#522448"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#662F42"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#906173"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#97954B"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#6F6580"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#FED674"),"color"))
        self.dataSource.addObject(NSDictionary(objectsAndKeys: UIColor().colorWithHex("#B1333E"),"color"))
    }
}

