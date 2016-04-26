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
        self.collView.dataArray = self.dataSource.mutableCopy() as! NSMutableArray
        self.collView.jgDatasource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK : UICollection View Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: JGCustomCell  = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! JGCustomCell;        
        let image_index = indexPath.row % 8;
        cell.backgroundImage.image = UIImage(named: "car\(image_index+1)")
        return cell;
    }
    
    //MARK : Button Actions
    @IBAction func refresh(sender: AnyObject) {
        self.collView.dataArray.removeAllObjects()
        self.collView.reloadData();
        self.collView.dataArray = self.dataSource.mutableCopy() as! NSMutableArray
        self.collView.reloadData();
    }
    
    //MARK : Helpers
    func loadData(){
        self.dataSource = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    }
}

