//
//  NoPreguntasPopOverViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 08/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class NoPreguntasPopOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Actions
    
    @IBAction func volver(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
