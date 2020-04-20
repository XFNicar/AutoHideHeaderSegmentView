

import UIKit

class ViewController: UIViewController,AutoHideHeaderSegmentDataSource,AutoHideHeaderSegmentDelegate,UITableViewDataSource {
  
    
    
    
    var mainScroll: MainSegmentView?
    var subTitles: [String] = ["sss","sss","sss"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubViews()
    }

    func initSubViews()  {
        mainScroll = MainSegmentView.init(frame: view.bounds)
        view.addSubview(mainScroll!)
        mainScroll?.isCustomerBarItem = true
        mainScroll?.dataSource = self
        mainScroll?.delegate = self
        mainScroll?.maxTopScrollHeight = 120
        mainScroll?.registBarItem(UINib.init(nibName: "CustomerBarItemCVCell", bundle: .main), forCellWithReuseIdentifier: "customerId")
        mainScroll!.reloadData()
    }
    
    func mainSegmentView(mainSegmentView: MainSegmentView, subScrollViewFor index: Int) -> UIScrollView {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }
    
    func mainSegmentView(mainSegmentView: MainSegmentView, barItemFor indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainSegmentView.dequeueReusableCell(withReuseIdentifier: "customerId", forIndexPath: indexPath) as! CustomerBarItemCVCell
        cell.updateUI(title: subTitles[indexPath.row])
        return cell
    }
    
    // 选用默认模式的话，必须返回
    func subTitleForPages(mainSegmentView: MainSegmentView) -> [String] {
        return subTitles
    }
    
    // 一共有多少个页面
    func numberOfPages(mainSegmentView: MainSegmentView) -> Int {
        return subTitles.count
    }
    
    // 当前选中哪一个页面
    func mainSegmentView(_ mainSegmentView: MainSegmentView, didSelectedat index: Int) {
        print("选中第\(index)个tableview")
    }
    
    func segmentBarItemWidth(mainSegmentView: MainSegmentView) -> CGFloat {
        return view.frame.width / 3
    }
    
    func segmentBarAutoContainerView(mainSegmentView: MainSegmentView) -> UIView? {
        let autoView: AutoContainerView = AutoContainerView.loadFromNib()
        return autoView
    }
    
    func mainScrollViewDidScroll(_ mainScrollView: UIScrollView) {
        let topHeight: CGFloat = (mainScroll?.maxTopScrollHeight)!
        let headAlpha = (topHeight - mainScrollView.contentOffset.y) / topHeight
        if headAlpha >= 1 {
            mainScroll?.autoHeaderView.alpha = 1
        } else if headAlpha >= 0 {
            mainScroll?.autoHeaderView.alpha = headAlpha
        } else {
            mainScroll?.autoHeaderView.alpha = 0
        }
    }
    
    // 子页面滚动
    func subScrollViewDidScroll(_ subScrollView: UIScrollView) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}

