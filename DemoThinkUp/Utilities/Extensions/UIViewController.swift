//
//  UIViewController.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showProgressHud(view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        
    }
    
    func hideProgressHud(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
