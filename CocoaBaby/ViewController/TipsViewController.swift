//
//  TipsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController, UIScrollViewDelegate {

    let weeks = Array(1...40)
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x: 10, y: 0, width: 0, height: 0)

    
    
    @IBOutlet var scrollView: UIScrollView!
//    @IBOutlet var tipsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<colors.count {
            
            frame.origin.x += (self.scrollView.frame.width ) * CGFloat(index)
            frame.size = CGSize(width: self.scrollView.frame.width - 20, height: self.scrollView.frame.height)
            self.scrollView.isPagingEnabled = true
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            self.scrollView.addSubview(subView)
        
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width  * CGFloat(colors.count), height: self.scrollView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let kMaxIndex : CGFloat = 23
        let targetX :CGFloat = scrollView.contentOffset.x + velocity.x * 60.0
        var targetIndex = round(targetX / (self.scrollView.frame.width - 20 + 10));
        if (targetIndex < 0) {
            targetIndex = 0;
        }
        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex;
        }
        targetContentOffset->x = targetIndex * (self.scrollView.frame.width - 20 + 10);

    }
        
//        
//        CloudKitController.shared.saveRecord(text: "teeeeeesst1")
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let itemWidthAndHeight = view.frame.width/4 - 25
//        
//        layout.sectionInset = UIEdgeInsets(top: 20 , left: 20, bottom: 20, right: 20)
//        layout.itemSize = CGSize(width: itemWidthAndHeight, height: itemWidthAndHeight)
//        layout.minimumInteritemSpacing = 20
//        layout.minimumLineSpacing = 20
//        
//        self.tipsCollectionView.collectionViewLayout = layout
//        
//        self.tipsCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
//        self.tipsCollectionView.delegate = self
//        self.tipsCollectionView.dataSource = self
//        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor = UIColor.mainBlueColor
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        
        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return weeks.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = tipsCollectionView.dequeueReusableCell(withReuseIdentifier: "TipsCollectionViewCell", for: indexPath) as! TipsCollectionViewCell 
//        cell.weekNum.text = String(weeks[indexPath.row])
//        cell.weekNum.lineBreakMode = .byWordWrapping
//        cell.weekNum.numberOfLines = 0
//        cell.weekNum.font = UIFont(name: cell.weekNum.font.fontName, size: 20)
//        cell.weekNum.textColor = .white
//        cell.weekLabel.textColor = UIColor.white
//        cell.backgroundColor = UIColor.clear
//        cell.layer.cornerRadius = 8
//        cell.layer.borderColor = UIColor.white.cgColor
//        cell.layer.borderWidth = 0.5
//        
//        if BabyStore.shared.getPregnantWeek().week == indexPath.row + 1 {
//            cell.backgroundColor = UIColor.white
//            cell.weekLabel.textColor = UIColor.mainBlueColor
//            cell.weekNum.textColor = UIColor.mainBlueColor
//        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "Tips", bundle: nil)
//        let tipsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "TipsDetailViewController") as! TipsDetailViewController
//        
//        self.present(tipsDetailViewController, animated: true, completion: nil)
//
//    }
    
//    // flow Layout
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return weeks.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tipsTabelView.dequeueReusableCell(withIdentifier: "TipsTabelViewCell", for: indexPath) as! TipsTableViewCell
//        
//        cell.title.text = self.weeks[indexPath.row]
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let tipsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "TipsDetailViewController") as! TipsDetailViewController
//        
//        self.navigationController?.pushViewController(tipsDetailViewController, animated: true)
//    }

}
