//
//  BusinessPopUpViewController.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 14/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit

protocol BusinessOptionProtocol: class {
    func businessSelected(_ business: BusinessSelection, businessDetail: BusinessDetail)
}

class BusinessPopUpViewController: UIViewController {
    
    @IBOutlet weak var showOnMapButton: UIButton!
    @IBOutlet weak var bookUberButton: UIButton!
    @IBOutlet weak var placeDetailButton: UIButton!
    @IBOutlet weak var controllContainerView: UIView!
    var businessDetail : BusinessDetail?
    var delegate: BusinessOptionProtocol!
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showOnMapButton.isExclusiveTouch         = true
        self.bookUberButton.isExclusiveTouch          = true
        self.placeDetailButton.isExclusiveTouch       = true
        controllContainerView.layer.cornerRadius    = 3.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        if (!controllContainerView.frame.contains(touchLocation)){
            self.dismiss(animated: true) { () -> Void in }
        }
    }
    
    // MARK:m - IBAction methods
    
    /*
    @description : Called when user click on place detail option in alert and then it will call the implemented delegate method
    @parameter   : sender of type UIButton
    @return      : no
    */
    @IBAction func placeDetailAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) { () -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
            
                self.delegate.businessSelected(BusinessSelection.placeDetail, businessDetail: self.businessDetail!)
            })
        }
    }
    
    
    /*
    @description : Called when user click on Book Uber option in alert and then it will call the implemented delegate method
    @parameter   : sender of type UIButton
    @return      : no
    */
    @IBAction func bookUberAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) { () -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
            
                self.delegate.businessSelected(BusinessSelection.bookUber, businessDetail: self.businessDetail!)
            })
        }
    }
    
    /*
    @description : Called when user click on Show On Map option in alert and then it will call the implemented delegate method
    @parameter   : sender of type UIButton
    @return      : no
    */
    @IBAction func showMapDirectionAction(_ sender: UIButton) {
        
        self.dismiss(animated: true) { () -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
            
                self.delegate.businessSelected(BusinessSelection.showDirection, businessDetail: self.businessDetail!)
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Logs.statementLog(segue.identifier)
    }
}
