//
//  AddLensViewController.swift
//  LensCounter
//
//  Created by Brent Eerlingen on 3/07/17.
//  Copyright © 2017 Brent Eerlingen. All rights reserved.
//

import UIKit
import os.log

class AddLensViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var activatedSwitch: UISwitch!
    
    var lens: Lens?
    @IBOutlet weak var imageView: UIImageView!
    
    var type: String?
    var isActivated: Bool!
    
    //MARK: Pickerview
    
    let typePickerDataSource = ["Month", "Week"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typePickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = typePickerDataSource[row]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        
        if let lens = lens {
            brandTextField.text = lens.brand
            switch lens.type {
            case "Month":
                typePickerView.selectedRow(inComponent: 0)
                 typePickerView.selectRow(0, inComponent: 0, animated: true)
            case "Week":
                typePickerView.selectedRow(inComponent: 0)
                 typePickerView.selectRow(1, inComponent: 0, animated: true)

            default:
                typePickerView.selectedRow(inComponent: 0)
            }
            
            if lens.isActivated {
                activatedSwitch.isOn = true
            } else {
                 activatedSwitch.isOn = false
            }
            
            imageView.image = lens.photo
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddLensMode = presentingViewController is UINavigationController
        
        if isPresentingInAddLensMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The AddLensesViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if type == nil {
           type = "Month" 
        }
        
        if activatedSwitch.isOn {
            isActivated = true
        } else {
            isActivated = false
        }
        
        let brand = brandTextField.text ?? ""
        
        let photo = imageView.image
        
        lens = Lens(brand: brand, type: type!, isActivated: isActivated, photo: photo)
     
    }


}
