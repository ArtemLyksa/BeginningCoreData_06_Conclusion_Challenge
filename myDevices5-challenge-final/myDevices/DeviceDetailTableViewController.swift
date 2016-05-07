/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

class DeviceDetailTableViewController: UITableViewController {
  var device: Device?
  var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deviceTypeTextField: UITextField!
    @IBOutlet weak var deviceOwnerLabel: UILabel!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var deviceIDTextfield: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseDateTextField.inputView = datePicker
        purchaseDateTextField.inputAccessoryView = toolBar
        purchaseDateTextField.delegate = self
    }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let device = device {
      nameTextField.text = device.name
      deviceTypeTextField.text = device.deviceType

      if let owner = device.owner {
        deviceOwnerLabel.text = "Device owner: \(owner.name)"
      } else {
        deviceOwnerLabel.text = "Set device owner"
      }
        if let deviceID = device.deviceID {
            deviceIDTextfield.text = deviceID
        }
        if let devicePurchaseData = device.purchaseData {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            purchaseDateTextField.text = dateFormatter.stringFromDate(devicePurchaseData)
        }
    }
  }
    @IBAction func cancelAction(sender: AnyObject) {
        purchaseDateTextField.resignFirstResponder()
    }

    @IBAction func doneAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        purchaseDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
        purchaseDateTextField.resignFirstResponder()

        
    }
    
  override func viewWillDisappear(animated: Bool) {
    if let device = device, name = nameTextField.text, deviceType = deviceTypeTextField.text {
      device.name = name
      device.deviceType = deviceType

    } else if device == nil {
      if let name = nameTextField.text, deviceType = deviceTypeTextField.text, entity = NSEntityDescription.entityForName("Device", inManagedObjectContext: managedObjectContext) where !name.isEmpty && !deviceType.isEmpty {
        device = Device(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        device?.name = name
        device?.deviceType = deviceType
      }
    }
    if let deviceID = deviceIDTextfield.text {
        device?.deviceID = deviceID
    }
    if let purchaseDate = purchaseDateTextField.text {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        device?.purchaseData = dateFormatter.dateFromString(purchaseDate)
    }

    do {
      try managedObjectContext.save()
    } catch {
      print("Error saving the managed object context!")
    }

  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      if let personPicker = storyboard?.instantiateViewControllerWithIdentifier("People") as? PeopleTableViewController {
        personPicker.managedObjectContext = managedObjectContext

        // more personPicker setup code here
        personPicker.pickerDelegate = self
        personPicker.selectedPerson = device?.owner

        navigationController?.pushViewController(personPicker, animated: true)
      }
    }

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension DeviceDetailTableViewController: PersonPickerDelegate {
  func didSelectPerson(person: Person) {
    device?.owner = person

    do {
      try managedObjectContext.save()
    } catch {
      print("Error saving the managed object context!")
    }
  }
}

extension DeviceDetailTableViewController: UITextFieldDelegate {
     func textFieldDidBeginEditing(textField: UITextField) {

        if let purchaseDate = purchaseDateTextField.text {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let datePurch = dateFormatter.dateFromString(purchaseDate) {
            datePicker.date = datePurch
            }
        }
    }

}























