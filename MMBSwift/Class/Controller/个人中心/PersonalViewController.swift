//
//  PersonalViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/29.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

enum Personal_Collection_type : String{
    case BaseInfo = "基本信息"
    case AccountInfo = "账户信息"
    case SupplierManage = "供应商管理"
    case CustomerManage = "客户管理"    //经销商
    case CommodityManage = "商品管理"
    case WareHouseManage = "仓储管理"
    case MyShop = "我的店铺"            //经销商
    case BusinessStatistics = "营业统计"
    case ZhanzhangGuanli = "站长管理"
    case ShequGuanli = "社区管理"
    case TuangouGuanli = "团购管理"
    case Yaoqingyouli = "邀请有礼"
    case StaffManage = "职员管理"  //主账号登录
    case StaffInfo = "个人信息"    //职员登录
    case AuthorityManagement = "权限管理"
    case AccountTransfer = "账户移交"
    case PrintManage = "打印管理"
    case VipManage = "会员管理"    //餐厅
    case FoodManage = "菜品管理"   //餐厅
    case ZhuotaigGuanli = "桌台管理"//餐厅
    case JifenGuanli = "积分管理"//餐厅
    case DiancanPingtai = "点餐平台"//餐厅
    //tableView内容
    case MyQRCode = "推广码"
    case MyDongtai = "我的动态"
    case Yingxiaotuisong = "营销推送"
    case AddressManage = "地址管理"
    case VehicleManage = "车辆管理"
    case TaskManage = "任务管理"
    case ChangePassword = "修改密码"
    case DeletedFriend = "已删除好友"
    case RecycleBin = "回收站"
    case VersionInfo = "版本信息"
}

class PersonalViewController: BaseViewController {

    var table : UITableView?
    var list : NSArray?
    var myCollectionView : UICollectionView?
    var collectionArray : NSArray?
    var dataModel : SupInfoObject?
    var img_avatar : UIImageView?
    var lab_name : UILabel?
    var lab_tel : UILabel?
    var lab_qrcode : UILabel?
    var qrcode_bk_view : UIView?
    var img_qrcode : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initCollectionArray()
        self.initTableArray()
        self.initialize()
        self.getUserInfo()
        NotificationTool.add(observer: self, selector: #selector(refreshView), notification: .refreshPersonView)
    }
    
    deinit {
        NotificationTool.remove(observer: self)
    }
}

//MARK:Selector
extension PersonalViewController {
    @objc private func logoutClick(){
        let actionSheet = UIAlertController.init(title: nil, message: "是否退出登录？", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let doneAction = UIAlertAction.init(title: "退出", style: .destructive) { (action) in
            logout()
            UIApplication.shared.keyWindow?.rootViewController = MMBNavigationController(rootViewController: LoginViewController())
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(doneAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func refreshView(){
        self.getUserInfo()
    }
    
    private func getUserInfo(){
        NetWorkRequest(.getSubownerInfo(owner_id: myOwnerId()), completion: { [weak self](jsonString) -> (Void) in
            let jsonModel : SupInfoJsonModel = jsonToModel(jsonString, SupInfoJsonModel.self) as! SupInfoJsonModel
            if jsonModel.head.code == 200{
                let model : SupInfoModel = jsonModel.body
                self?.dataModel = model.datas
                self?.setHeaderData()
            }else{
                CBToast.showToastAction(message: "\(jsonModel.head.msg ?? "")" as NSString)
            }
        }) { (errorString) -> (Void) in
            
        };
    }
    
    private func setHeaderData(){
        if (dataModel?.head_url?.count)! > 0 {
            img_avatar?.kf.setImage(with: URL(string: appendUrl(url: dataModel!.head_url!)), placeholder: UIImage(named: "head"))
        }
        if myPersonId() == "-1" {
            lab_name?.text = dataModel?.name
        }else{
            lab_name?.text = "\(dataModel?.name ?? "")\n\(myStaffName()) \(myStation())"
        }
        lab_tel?.text = dataModel?.telphone
        if myStation() == "采购" || myPersonId() == "-1" {
            lab_qrcode?.text = "采购码"
            qrcode_bk_view?.isHidden = false
            img_qrcode?.kf.setImage(with: URL(string: appendUrl(url: dataModel?.endWatImage_small_purchase ?? "")))
        }else if myStation() == "销售" || myStation() == "开单员" || myStation() == "司机"{
            lab_qrcode?.text = "店铺码"
            qrcode_bk_view?.isHidden = false
            img_qrcode?.kf.setImage(with: URL(string: appendUrl(url: dataModel?.watimage ?? "")))
        }
    }
}

//MARK:跳转方法
extension PersonalViewController {
    fileprivate func changePassword(){
        let changePasswordController = FindPasswordViewController()
        changePasswordController.isLogin = true
        changePasswordController.title = "修改密码"
        self.navigationController?.pushViewController(changePasswordController, animated: true)
    }
    
    fileprivate func changePhone(){
        let changePhoneController = ChangePhoneViewController()
        changePhoneController.title = "验证旧手机"
        self.present(MMBNavigationController(rootViewController: changePhoneController), animated: true, completion: nil)
//        self.navigationController?.pushViewController(changePhoneController, animated: true)
    }
}

//MARK:UITableViewDataSource,UITableViewDelegate
extension PersonalViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr : NSArray = list![section] as! NSArray
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PersonalTableViewCell = table?.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let arr : NSArray = list![indexPath.section] as! NSArray
        let infos : NSArray = arr[indexPath.row] as! NSArray
        let type : Personal_Collection_type = infos[0] as! Personal_Collection_type
        let imgName : String = infos[1] as! String
        cell.imgV_icon.image = UIImage(named: imgName)
        cell.lab_Name.text = type.rawValue
        if type == Personal_Collection_type.VersionInfo {
            let infoDictionary = Bundle.main.infoDictionary
            let version = infoDictionary!["CFBundleShortVersionString"]
            cell.labContent.text = version as? String
        }else{
            cell.labContent.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: AppFrame.kScreenWidth, height: 10))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr : NSArray = list![indexPath.section] as! NSArray
        let infos : NSArray = arr[indexPath.row] as! NSArray
        let type : Personal_Collection_type = infos[0] as! Personal_Collection_type
        switch type {
        case .MyQRCode: break
            
        case .MyDongtai: break
            
        case .Yingxiaotuisong: break
            
        case .AddressManage: break
            
        case .VehicleManage: break
            
        case .TaskManage: break
            
        case .ChangePassword:
            self.changePassword()
        case .DeletedFriend: break
            
        case .RecycleBin: break
            
        case .VersionInfo: break
            
        default:
            break
        }
    }
}

extension PersonalViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PersonalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalCollectionViewCell", for: indexPath) as! PersonalCollectionViewCell
        let infos : NSArray = collectionArray![indexPath.row] as! NSArray
        let type : Personal_Collection_type = infos[0] as! Personal_Collection_type
        let imgName : String = infos[1] as! String
        cell.labName.text = type.rawValue
        cell.imgView.image = UIImage(named: imgName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infos : NSArray = collectionArray![indexPath.row] as! NSArray
        let type : Personal_Collection_type = infos[0] as! Personal_Collection_type
        switch type {
        case .AccountInfo:
            print("\(Personal_Collection_type.AccountInfo.rawValue)")
        case .AccountTransfer:
            self.changePhone()
        default:
            print("\(type.rawValue)")
        }
    }
}

//MARK:初始化
extension PersonalViewController {
    fileprivate func initCollectionArray(){
        collectionArray = [[Personal_Collection_type.BaseInfo,"ic_wd_jbxx"],[Personal_Collection_type.AccountInfo,"ic_wd_zhxx"],[Personal_Collection_type.SupplierManage,"ic_wd_gysgl"],[Personal_Collection_type.CustomerManage,"ic_wd_khgl"],[Personal_Collection_type.CommodityManage,"ic_wd_spgl"],[Personal_Collection_type.WareHouseManage,"ic_wd_ccgl"],[Personal_Collection_type.MyShop,"ic_wd_wddp"],[Personal_Collection_type.BusinessStatistics,"ic_wd_yytj"],[Personal_Collection_type.ZhanzhangGuanli,"ic_wd_zzgl"],[Personal_Collection_type.ShequGuanli,"ic_wd_sqgl"],[Personal_Collection_type.TuangouGuanli,"ic_wd_tggl"],[Personal_Collection_type.Yaoqingyouli,"ic_wd_yqgl"],[Personal_Collection_type.StaffManage,"ic_wd_zygl"],[Personal_Collection_type.AuthorityManagement,"ic_wd_qxgl"],[Personal_Collection_type.AccountTransfer,"ic_wd_zhyj"],[Personal_Collection_type.PrintManage,"ic_wd_dygl"]]
    }
    
    fileprivate func initTableArray() {
        let section_0 : NSArray = [[Personal_Collection_type.MyQRCode,"ic_wd_tgm"]] as NSArray
        let section_1 : NSArray = [[Personal_Collection_type.MyDongtai,"ic_wd_dongtai"],[Personal_Collection_type.Yingxiaotuisong,"ic_wd_yxts"],[Personal_Collection_type.AddressManage,"ic_wd_dzgl"],[Personal_Collection_type.VehicleManage,"ic_wd_clgl"],[Personal_Collection_type.TaskManage,"ic_wd_rwgl"],[Personal_Collection_type.ChangePassword,"ic_wd_xgmm"],[Personal_Collection_type.DeletedFriend,"ic_wd_yschy"],[Personal_Collection_type.RecycleBin,"ic_wd_hsz"],[Personal_Collection_type.VersionInfo,"ic_wd_bbxx"]] as NSArray
        list = [section_0,section_1]
    }
    
    fileprivate func initialize(){
        let rightbar = UIBarButtonItem(title: "退出", style: .done, target: self, action: #selector(logoutClick))
        self.navigationItem.rightBarButtonItem = rightbar
        
        table = UITableView.init(frame: CGRect.zero, style: .plain)
        table?.dataSource = self
        table?.delegate = self
        self.view.addSubview(table!)
        table?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(AppFrame.kHeight_StatusBarAndNavigationBar)
            make.bottom.equalTo(self.view).offset(-AppFrame.kHeight_TabBar)
        })
        self.view.backgroundColor = AppColor.lightGray2
        table?.backgroundColor = AppColor.lightGray2
        table?.tableFooterView = UIView()
        table?.tableHeaderView = self.tableHeader()
        table?.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
    }
    
    fileprivate func tableHeader() -> UIView{
        let head_view = UIView(frame: CGRect(x: 0, y: 0, width: AppFrame.kScreenWidth, height: 465))
        head_view.backgroundColor = UIColor.clear
        
        let user_view = UIView(frame: CGRect(x: 0, y: 0, width: AppFrame.kScreenWidth, height: 105))
        user_view.backgroundColor = UIColor.white
        head_view.addSubview(user_view)
        
        img_avatar = UIImageView.init()
        img_avatar?.layer.masksToBounds = true
        img_avatar?.layer.cornerRadius = 38
//        img_avatar?.layer.borderWidth = 1
        user_view.addSubview(img_avatar!)
        img_avatar?.snp.makeConstraints { (make) in
            make.left.equalTo(user_view).offset(20)
            make.height.width.equalTo(76)
            make.centerY.equalTo(user_view)
        }
        
        lab_name = UILabel.init()
        lab_name?.numberOfLines = 0
        lab_name?.text = "好旺"
        lab_name?.font = UIFont.boldSystemFont(ofSize: 17)
        lab_name?.textColor = .black
        user_view.addSubview(lab_name!)
        lab_name!.snp.makeConstraints { (make) in
            make.left.equalTo(img_avatar!.snp.right).offset(20)
            make.top.equalTo(img_avatar!)
            make.height.greaterThanOrEqualTo(40)
        }
        
        lab_tel = UILabel.init()
        lab_tel?.text = ""
        lab_tel?.font = FONT(font: 15)
        lab_tel?.textColor = .darkGray
        user_view.addSubview(lab_tel!)
        lab_tel!.snp.makeConstraints { (make) in
            make.left.equalTo(lab_name!)
            make.bottom.equalTo(img_avatar!).offset(-10)
            make.height.equalTo(20)
        }
        
        lab_qrcode = UILabel.init()
        lab_qrcode?.font = FONT(font: 13)
        lab_qrcode?.textColor = .gray
        lab_qrcode?.textAlignment = .center
        lab_qrcode?.text = ""
        user_view.addSubview(lab_qrcode!)
        lab_qrcode!.snp.makeConstraints { (make) in
            make.right.equalTo(user_view).offset(-15)
            make.top.equalTo(user_view).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(60)
        }
        
        qrcode_bk_view = UIView.init()
        qrcode_bk_view?.backgroundColor = .clear
        qrcode_bk_view?.layer.borderColor = UIColor.lightGray.cgColor
        qrcode_bk_view?.layer.borderWidth = 1
        qrcode_bk_view?.isHidden = true
        user_view.addSubview(qrcode_bk_view!)
        qrcode_bk_view?.snp.makeConstraints { (make) in
            make.right.equalTo(user_view).offset(-15)
            make.top.equalTo(user_view).offset(30)
            make.width.height.equalTo(60)
        }
        
        img_qrcode = UIImageView.init()
        img_qrcode?.backgroundColor = .clear
        qrcode_bk_view!.addSubview(img_qrcode!)
        img_qrcode?.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(qrcode_bk_view!)
            make.width.height.equalTo(50)
        }
        
        let collection_bk_view = UIView(frame: CGRect(x: 0, y: user_view.bottom+10, width: AppFrame.kScreenWidth, height: 350))
        collection_bk_view.backgroundColor = .white
        head_view.addSubview(collection_bk_view)
//        collection_bk_view.snp.makeConstraints { (make) in
//            make.left.right.equalTo(head_view)
//            make.top.equalTo(user_view.snp.bottom).offset(10)
//            make.height.equalTo(350)
//        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = (AppFrame.kScreenWidth-30-70*4)/3-3
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        myCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView?.backgroundColor = .white
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        collection_bk_view.addSubview(myCollectionView!)
        myCollectionView?.register(UINib.init(nibName: "PersonalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PersonalCollectionViewCell")
        myCollectionView?.snp.makeConstraints({ (make) in
            make.left.equalTo(collection_bk_view).offset(15)
            make.right.equalTo(collection_bk_view).offset(-15)
            make.bottom.equalTo(collection_bk_view)
            make.top.equalTo(collection_bk_view).offset(10)
        })
        
        return head_view
    }
}
