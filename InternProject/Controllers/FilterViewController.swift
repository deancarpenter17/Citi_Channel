//
//  FilterViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/26/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var filterTableView: UITableView!
    
    let sorts = ["Newest","Oldest","Popular"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortCell = tableView.dequeueReusableCell(withIdentifier: "sortingOptionCell", for: indexPath) as! SortingOptionsCell
        sortCell.sortingLbl.text = sorts[indexPath.row]
        
        return sortCell
    }
    

}
