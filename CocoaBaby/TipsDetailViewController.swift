//
//  TipsDetailViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let sectionHeight : CGFloat = 40
    var currentContent : String = ""
    
    let segmentedControl = UISegmentedControl(items: ["baby","mama","papa"])
    
    var week : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        segmentedControl.selectedSegmentIndex = 0
        
        // 데이터 모델 만든 뒤 수정 필요
        currentContent = cont[0]
        //
        self.segmentedControl.addTarget(self, action: #selector(tipTargetChanged(segControl:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if week == nil {
            week = 1
        }

    }
    
    func tipTargetChanged(segControl : UISegmentedControl)  {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentContent = cont[0]
        case 1:
            currentContent = cont[1]
        case 2:
            currentContent = cont[1]
        default:
            break
        }
        self.tableView.reloadData()
    }

}

extension TipsDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? "TipsDetailHeaderTableViewCell" : "TipsDetailContentTableViewCell"
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TipsDetailHeaderTableViewCell
            if let week = week {
                cell.initWeekTitle(week: week)
            }
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TipsDetailContentTableViewCell
            cell.setContent(content: currentContent)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {

            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: sectionHeight))
            sectionView.addSubview(segmentedControl)
            
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            
            
            let topConstraint = segmentedControl.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 5)
            let bottomConstraint = segmentedControl.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor,constant: -5)
            let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 10)
            let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant : -10)
            
            topConstraint.isActive = true
            bottomConstraint.isActive = true
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true

            segmentedControl.tintColor = .gray
            
            return sectionView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ?  100 : 1000
    }
}
// 수정 필요
let cont = ["       태아는 이미 성별, 피부색, 머리카락 모양 등 대부분의 유전형질이 결정되어 있는 상태입니다. 머리가 몸 전체의 1/3을 차지하며 눈의 색소 침착도 확실해집니다. 아직 태아처럼 보이지는 않지만 뇌가 생기기 시작합니다. 신장이나 심장과 같은 주요 장기들도 발달하며 손가락, 발가락, 눈이 생기며, 4cm까지 성장합니다. 그러나 아직 엄마는 몸 속에서 일어나는 이 드라마틱한 변화를 느낄 수는 없습니다","        대개 월경 예정일에 월경이 없음으로 임신을 예상하게 됩니다. 자궁의 크기는 레몬 정도가 됩니다. 입덧 증세가 생기며 유방이 아프고 팽창되어 당기는 느낌이 듭니다. 소변 횟수도 잦아지고 졸음과 초조함이 나타나기도 합니다. \n\n        임신 초기에 자궁이 골반 안에서 커짐에 따라 소변을 자주 보는 증상이 보입니다. 임신 중기가 되면 자궁이 골반 위로 올라가 자연스럽게 좋아집니다. 임신 중에는 수분은 많이 섭취하되, 커피, 홍차, 콜라 등은 이뇨 작용을 일으키므로 많이 마시지 않는 것이 좋습니다.\n\n        아직까지 외형적인 변화가 없어서 임신 전의 옷을 입어도 불편함이 없으나 복압을 높일 수 있는 너무 꼭 조이는 옷은 피하도록 합니다."]


