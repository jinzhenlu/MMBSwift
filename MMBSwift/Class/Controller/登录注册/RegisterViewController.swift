//
//  RegisterViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/20.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    var txtName : UITextField?
    var txtCode : UITextField?
    var btnCmd : UIButton?
    var txtPassword : UITextField?
    var btnDone : UIButton?
    
    var myTimer: ZJTimer!
    var time: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "找回密码"
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
extension RegisterViewController {
    @objc private func getAuthCode(){
        if checkMobile(txtName!.text! as NSString) {
            NetWorkRequest(.getVerifyCode(telphone: txtName!.text!), completion: { (resultString) -> (Void) in
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
            btnCmd?.setTitle(NSString(format: "%d秒", time) as String, for: .normal)
            btnCmd?.isEnabled = false
        }else{
            btnCmd?.setTitle("获取验证码", for: .normal)
            btnCmd?.isEnabled = true
            myTimer.invalidate()
            myTimer = nil
        }
    }
    
    @objc private func doneClick(){
        if txtName?.text?.count == 0 || txtCode?.text?.count == 0 || txtPassword?.text?.count == 0 {
            CBToast.showToastAction(message: "请正确填写所有信息")
            return
        }
        if (txtPassword?.text!.count)! < 6 {
            CBToast.showToastAction(message: "密码不能少于6位")
            return
        }
        self.view.endEditing(true)
        let password = txtPassword!.text! + ".*.-"
        let md5_psw = password.md5()
        let md5_psw_2 = md5_psw.md5()
        let body = LoginBody()
        body.telphone = txtName?.text
        body.password = md5_psw_2
        body.deivceid = "ios"
        body.cmd = txtCode?.text
        let params = modelToDictionary(body)
        NetWorkRequest(.register(params: params), completion: { [weak self](jsonString) -> (Void) in
            let model:HeadModel = jsonToModel(jsonString, HeadModel.self) as! HeadModel
            CBToast.showToastAction(message: model.head!.msg! as NSString)
            if model.head.code == 200 {
                self?.navigationController?.popViewController(animated: true)
            }
        }) { (failString) -> (Void) in
            
        }
    }
    
    fileprivate func initialize(){
        self.view.backgroundColor = .white
        txtName = UITextField()
        txtName?.placeholder = "  手机号"
        txtName?.font = FONT(font: 15)
        txtName?.backgroundColor = AppColor.lightGray2
        txtName?.layer.masksToBounds = true
        txtName?.layer.cornerRadius = 8
        txtName?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txtName?.keyboardType = UIKeyboardType.phonePad
        self.view.addSubview(txtName!)
        
        txtName?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(AppFrame.kHeight_StatusBarAndNavigationBar+30)
            make.height.equalTo(45)
        })
        
        txtCode = UITextField()
        txtCode?.placeholder = "  验证码"
        txtCode?.font = FONT(font: 15)
        txtCode?.backgroundColor = AppColor.lightGray2
        txtCode?.layer.masksToBounds = true
        txtCode?.layer.cornerRadius = 8
        txtCode?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txtCode?.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(txtCode!)
        txtCode?.snp.makeConstraints({ (make) in
            make.left.height.equalTo(txtName!)
            make.right.equalTo(self.view).offset(-120)
            make.top.equalTo(txtName!.snp.bottom).offset(20)
        })
        
        btnCmd = UIButton(type: .custom)
        btnCmd?.setTitleColor(AppColor.blue, for: .normal)
        btnCmd?.layer.masksToBounds = true
        btnCmd?.layer.cornerRadius = 5
        btnCmd?.layer.borderWidth = 0.5
        btnCmd?.layer.borderColor = AppColor.blue.cgColor
        btnCmd?.setTitle("获取验证码", for: .normal)
        btnCmd?.titleLabel?.font = FONT(font: 14)
        btnCmd?.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        self.view.addSubview(btnCmd!)
        btnCmd?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(txtCode!)
            make.right.equalTo(txtName!)
            make.left.equalTo(txtCode!.snp.right).offset(20)
            make.height.equalTo(35)
        })
        
        txtPassword = UITextField()
        txtPassword?.placeholder = "  密码"
        txtPassword?.backgroundColor = AppColor.lightGray2
        txtPassword?.font = FONT(font: 15)
        txtPassword?.layer.masksToBounds = true
        txtPassword?.layer.cornerRadius = 8
        txtPassword?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txtPassword?.isSecureTextEntry = true
        self.view.addSubview(txtPassword!)
        txtPassword?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(txtName!)
            make.top.equalTo(txtCode!.snp.bottom).offset(20)
        })
        
        btnDone = UIButton(type: .custom)
        btnDone?.backgroundColor = AppColor.blue
        btnDone?.setTitle("注册", for: .normal)
        btnDone?.titleLabel?.font = FONT(font: 16)
        btnDone?.setTitleColor(.white, for: .normal)
        btnDone?.layer.masksToBounds = true
        btnDone?.layer.cornerRadius = 8
        btnDone?.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        self.view.addSubview(btnDone!)
        btnDone?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(txtName!)
            make.top.equalTo(txtPassword!.snp.bottom).offset(30)
        })
    }
}
