//
//  Anotation.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 04/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit
import MapKit

class Anotation: NSObject {

    var businessDetail : BusinessDetail
    var businessDistance : Double?
    
    init(business: BusinessDetail) {
        self.businessDetail = business
        super.init()
    }
    
    func calloutCell(){
        
    }
}
