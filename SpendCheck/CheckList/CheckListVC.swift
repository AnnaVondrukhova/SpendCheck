//
//  CheckListVC.swift
//  SpendCheck
//
//  Created by Anya on 14/03/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import UIKit
import RealmSwift
import RxRealm

class CheckListVC: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            sideMenuBtn.target = self.revealViewController()
            sideMenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }


}

