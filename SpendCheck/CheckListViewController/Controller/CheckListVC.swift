//
//  CheckListVC.swift
//  SpendCheck
//
//  Created by Anya on 14/03/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import UIKit
import CoreData
class CheckListVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    var checks: [Check] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "CheckCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "checkCell")
        
        if self.revealViewController() != nil {
            sideMenuBtn.target = self.revealViewController()
            sideMenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let context = SaveService.getContext()
        let fetchRequest: NSFetchRequest<Check> = Check.fetchRequest()
        
        do {
            checks = try context.fetch(fetchRequest)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("Check list VC did load: ", checks.first?.shop!)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let checkItems = checks[indexPath.row].checkItems?.array as! [CheckItem]
            let destinationVC = segue.destination as! CheckItemsTableVC
            destinationVC.checkItems = checkItems
            
        }
    }

}

extension CheckListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCheckItemsSegue", sender: self)
    }
    
}

extension CheckListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows")
        return checks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell fo row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCell
        let checkName = checks[indexPath.row].shop!
        let checkSum = checks[indexPath.row].sum
        
        
        cell.shopLabel.text = checkName
        cell.sumLabel.text = "\(checkSum)"
        cell.categoryLabel.text = "Продукты"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
