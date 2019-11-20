//
//  ScanVC.swift
//  SpendCheck
//
//  Created by Anya on 14/03/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import UIKit

class ScanVC: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            sideMenuBtn.target = self.revealViewController()
            sideMenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
