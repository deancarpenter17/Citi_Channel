//
//  SolutionReplyViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/24/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class SolutionReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
  //START OF TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let replyCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath)
        
        return replyCell
    }
    //END OF TABLE VIEW
    
}
