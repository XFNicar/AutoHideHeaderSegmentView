

import UIKit

class ViewController: UIViewController,AutoHideHeaderSegmentDataSource,AutoHideHeaderSegmentDelegate,UITableViewDataSource {

    var mainScroll: AutoHideHeaderSegmentView?
    var subTitles: [String] = ["全部","全部","全部","全部","全部","全部","全部"]
    var youpinSegView: SegmentView?
    var huozhuSegView: SegmentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubViews()
    }

    func initSubViews()  {
        mainScroll = AutoHideHeaderSegmentView.init(frame: view.bounds)
        view.addSubview(mainScroll!)
//        let headView = HeaderView.loadFromNib()
//        headView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
//        mainScroll?.autoHeaderView = headView
        mainScroll?.isCustomerBarItem = true
        mainScroll?.dataSource = self
        mainScroll?.delegate = self
        mainScroll?.maxTopScrollHeight = 120
        mainScroll?.registBarItem(UINib.init(nibName: "CustomerBarItemCVCell", bundle: .main), forCellWithReuseIdentifier: "customerId")
        mainScroll!.reloadData()
    }
    func mainSegmentView(mainSegmentView: AutoHideHeaderSegmentView, subScrollViewFor index: Int) -> UIScrollView {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }
    
    func mainSegmentView(mainSegmentView: AutoHideHeaderSegmentView, barItemFor indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainSegmentView.dequeueReusableCell(withReuseIdentifier: "customerId", forIndexPath: indexPath) as! CustomerBarItemCVCell
        cell.updateUI(title: subTitles[indexPath.row])
        return cell
    }

    // 一共有多少个页面
    func numberOfPages(mainSegmentView: AutoHideHeaderSegmentView) -> Int {
        return subTitles.count
    }
    
    // 当前选中哪一个页面
    func mainSegmentView(_ mainSegmentView: AutoHideHeaderSegmentView, didSelectedat index: Int) {
        print("选中第\(index)个tableview")
    }
    
    func segmentBarItemWidth(mainSegmentView: AutoHideHeaderSegmentView) -> CGFloat {
        return view.frame.width / 4
    }
    
    func segmentBarAutoContainerView(mainSegmentView: AutoHideHeaderSegmentView) -> UIView? {
        let autoView: AutoContainerView = AutoContainerView.loadFromNib()
        return autoView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
    
    // 子页面滚动
    func subScrollViewDidScroll(_ subScrollView: UIScrollView) {
        
    }
    
    // 选用默认模式的话，必须返回
    func subTitleForPages(mainSegmentView: AutoHideHeaderSegmentView) -> [String] {
        return subTitles
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

    
}

