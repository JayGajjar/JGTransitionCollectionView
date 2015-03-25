# JGTransitionCollectionView
=================================

A iOS swift base collectionview with unique animation feature inspired from behance made using UICollectionView.
https://www.behance.net/gallery/13691641/GIF-Abracadabra-App

![alt tag](https://github.com/JayGajjar/JGTransitionCollectionView/blob/master/JGTransitionCollectionView/JGTransitionCollectionView.gif)

# Installation
    Copy all the files form JGTransitionCollectionView/classes folder. 
    Assign class JGTransitionCollectionView to UICollectionView from storyboard

# Usage
Simply use it as normal collection view by calling its delegate and datasource methods

Assign datasource array
	self.collView.setDataArray(self.dataSource)
	
Assign datasource delegate
    self.collView.jgDatasource = self;


# Demo
JGTransitionCollectionView includes a sample project and revelent classes.

# Compatibility
- This project uses swift.
- This project was tested with iOS 7 & 8.

# License
JGTransitionCollectionView is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
