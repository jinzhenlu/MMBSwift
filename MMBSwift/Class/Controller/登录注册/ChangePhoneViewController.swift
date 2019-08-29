//
//  ChangePhoneViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/29.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class ChangePhoneViewController: BaseViewController {
    var txt_name: UITextField?
    var txt_code: UITextField?
    var btn_sendCode: UIButton?
    var btn_done: UIButton?
    
    //0:验证旧手机号页面 1:换绑新手机号页面
    var type : Int = 0
    var oldPhone : String?
    var myTimer: ZJTimer!
    var time: Int = 60
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }
    deinit{
        if myTimer != nil {
            myTimer.invalidate()
            myTimer = nil
        }
    }
}

//MARK:初始化
extension ChangePhoneViewController {
    @objc private func getAuthCode(){
        if checkMobile(txt_name!.text! as NSString) {
            NetWorkRequest(.getVerifyCode(telphone: txt_name!.text!), completion: { (resultString) -> (Void) in
                let model : HeadModel = jsonToModel(resultString, HeadModel.self) as! HeadModel
                if model.head.code == 200 {
                    self.time = 60
                    self.myTimer = ZJTimer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                }
            }, failed: { (str) -> (Void) in
                
            }) { () -> (Void) in
                
            }
        }else{
            CBToast.showToastAction(message: "请输入正确的手机号")
        }
    }
    
    @objc private func countDown(){
        self.time -= 1
        if time > 0 {
            btn_sendCode?.setTitle(NSString(format: "%d秒", time) as String, for: .normal)
            btn_sendCode?.isEnabled = false
        }else{
            btn_sendCode?.setTitle("获取验证码", for: .normal)
            btn_sendCode?.isEnabled = true
            myTimer.invalidate()
            myTimer = nil
        }
    }
    
    @objc private func doneClick(){
        if checkMobile(txt_name!.text! as NSString) {
            if txt_code!.text!.count == 0 {
                CBToast.showToastAction(message: "验证码不能为空")
            }else{
                if type == 0 {
                    self.requestServerForVerifyOldPhone()
                }else{
                    self.requestServerForChangeNewPhone()
                }
            }
        }else{
            CBToast.showToastAction(message: "请输入正确的手机号")
        }
    }
    
    private func requestServerForVerifyOldPhone(){
        let body = LoginBody()
        body.telphone = txt_name?.text
        body.cmd = txt_code?.text
        body.sup_id = myUserId()
        let params = modelToDictionary(body)
        NetWorkRequest(.checkOldTel(params: params), completion: { [weak self](jsonString) -> (Void) in
            let model : HeadModel = jsonToModel(jsonString, HeadModel.self) as! HeadModel
            if model.head.code == 200 {
                self?.gotoChange()
            }else{
                CBToast.showToastAction(message: model.head!.msg! as NSString)
            }
        }) { (errorString) -> (Void) in
            
        }
    }
    
    private func requestServerForChangeNewPhone(){
        let body = LoginBody()
        body.new_telphone = txt_name?.text
        body.cmd = txt_code?.text
        body.sup_id = myUserId()
        body.telphone = oldPhone
        let params = modelToDictionary(body)
        NetWorkRequest(.changeTel(params: params), completion: { [weak self](jsonString) -> (Void) in
            let model : HeadModel = jsonToModel(jsonString, HeadModel.self) as! HeadModel
            if model.head.code == 200 {
                NotificationTool.post(notification: .refreshPersonView)
                self?.dismiss(animated: true, completion: nil)
            }else{
                CBToast.showToastAction(message: model.head!.msg! as NSString)
            }
        }) { (errorString) -> (Void) in
            
        }
    }
    
    private func gotoChange(){
        let changePhoneController = ChangePhoneViewController()
        changePhoneController.title = "换绑新手机"
        changePhoneController.type = 1
        changePhoneController.oldPhone = txt_name?.text
        self.navigationController?.pushViewController(changePhoneController, animated: true)
    }
    
    @objc private func backButtonClick(){
        if type == 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func initialize(){
        self.view.backgroundColor = .white
        if (self.navigationController?.viewControllers.count)! == 1 {
            backBarItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .plain, target: self, action: #selector(backButtonClick))
            self.navigationItem.leftBarButtonItem = backBarItem
        }
        
        txt_name = UITextField()
        txt_name?.placeholder = "  原手机号"
        if type == 1 {
            txt_name?.placeholder = "  新手机号"
        }
        txt_name?.font = FONT(font: 15)
        txt_name?.backgroundColor = AppColor.lightGray2
        txt_name?.layer.masksToBounds = true
        txt_name?.layer.cornerRadius = 8
        txt_name?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txt_name?.keyboardType = UIKeyboardType.phonePad
        self.view.addSubview(txt_name!)
        
        txt_name?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(AppFrame.kHeight_StatusBarAndNavigationBar+30)
            make.height.equalTo(45)
        })
        
        txt_code = UITextField()
        txt_code?.placeholder = "  验证码"
        txt_code?.font = FONT(font: 15)
        txt_code?.backgroundColor = AppColor.lightGray2
        txt_code?.layer.masksToBounds = true
        txt_code?.layer.cornerRadius = 8
        self.view.addSubview(txt_code!)
        txt_code?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txt_code?.keyboardType = UIKeyboardType.numberPad
        txt_code?.snp.makeConstraints({ (make) in
            make.top.equalTo(txt_name!.snp.bottom).offset(20)
            make.right.equalTo(self.view).offset(-120)
            make.left.height.equalTo(txt_name!)
        })
        
        btn_sendCode = UIButton(type: .custom)
        btn_sendCode?.setTitleColor(AppColor.blue, for: .normal)
        btn_sendCode?.layer.masksToBounds = true
        btn_sendCode?.layer.cornerRadius = 5
        btn_sendCode?.layer.borderWidth = 0.5
        btn_sendCode?.layer.borderColor = AppColor.blue.cgColor
        btn_sendCode?.setTitle("获取验证码", for: .normal)
        btn_sendCode?.titleLabel?.font = FONT(font: 14)
        btn_sendCode?.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        self.view.addSubview(btn_sendCode!)
        btn_sendCode?.snp.makeConstraints({ (make) in
            make.right.equalTo(txt_name!)
            make.centerY.equalTo(txt_code!)
            make.left.equalTo(txt_code!.snp.right).offset(20)
            make.height.equalTo(35)
        })
        
        btn_done = UIButton(type: .custom)
        btn_done?.backgroundColor = AppColor.blue
        btn_done?.setTitle("确定", for: .normal)
        btn_done?.titleLabel?.font = FONT(font: 16)
        btn_done?.setTitleColor(.white, for: .normal)
        btn_done?.layer.masksToBounds = true
        btn_done?.layer.cornerRadius = 8
        btn_done?.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        self.view.addSubview(btn_done!)
        btn_done?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(txt_name!)
            make.top.equalTo(txt_code!.snp.bottom).offset(30)
        })
    }
}
