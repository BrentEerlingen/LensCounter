//
//  FirstViewController.swift
//  LensCounter
//
//  Created by Brent Eerlingen on 2/07/17.
//  Copyright © 2017 Brent Eerlingen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var lenses = [Lens]()

    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load any saved meals, otherwise load sample data.
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if let savedLenses = loadLenses() {
            lenses += savedLenses
        }
        
        var lens: Lens
        
        for l in lenses {
            if l.isActivated {
                lens = l
                counterLabel.text = String (lens.counter)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let savedLenses = loadLenses() {
            lenses += savedLenses
        }
        
        var lens: Lens
        
        for l in lenses {
            if l.isActivated {
                lens = l
                counterLabel.text = String (lens.counter)
            }
        }
    }

    private func loadLenses() -> [Lens]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Lens.ArchiveURL.path) as? [Lens]
    }

}

