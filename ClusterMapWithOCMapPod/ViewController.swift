//
//  MapViewController.swift
//  Should I Go
//
//  Created by Nitin Bhatia on 17/06/2019.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit
import MapKit
import OCMapView
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, BusinessOptionProtocol,CLLocationManagerDelegate{
    
    
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var testingButton: UIButton!
    @IBOutlet weak var offerButton: UIButton!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchViewLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var mapView: OCMapView!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var selectedBusinessDetail : BusinessDetail!
    var businesses: [BusinessDetail]!
    var intialBusinessData = Bool()
    var selectedAnnotation : MKAnnotation!
    var testingCoordinate : CLLocationCoordinate2D!
    var calloutAnnoation : CalloutAnnotation?
    var selectedAnnotationView: MKAnnotationView?
    var currentZoomLevel : MKZoomScale?
    var calloutAnnotationTitle = String("")
    var currentbusinessNo : NSInteger?
    var currentRadius : NSInteger?
    var tapCoordinate : CLLocationCoordinate2D?
    var oldCenter : CLLocation!
    var isSearchedFromMoving : Bool =  false
    var calledOneTime = false
    var timerStand : Timer = Timer()
    private var mapChangedFromUserInteraction = false
    var locationManager = CLLocationManager()
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assigning default value for mapView
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

//        navigationView.backgroundColor = UIColor(patternImage: UIImage(named: "top-img.png")!)
        
        let business  = UserDefaults.standard.integer(forKey: NAUserDefaultBusinessKey)
        
        if business != 0{
            
            CommonMethod.noOfBusiness = business
            
        }else{
            
            CommonMethod.noOfBusiness = 20
        }
        
        let radius  = UserDefaults.standard.integer(forKey: NAUserDefaultRadiusKey)
        
        if radius != 0{
            
            CommonMethod.businessRadius = radius
            
        }else{
            
            CommonMethod.businessRadius = 5
        }
        
        if Testing{
            
            testingButton.isHidden = false
            latTextField.isHidden  = false
            longTextField.isHidden = false
        }
        
       // searchView.inputAccessoryView                   = toolBar
        currentbusinessNo                               = CommonMethod.noOfBusiness
        currentRadius                                   = CommonMethod.businessRadius
        self.mapView.clusterSize                        = 0.2
        self.mapView.minLongitudeDeltaToCluster         = 0.0
        //this variable is used for QA Testing comment all its code before sending to client
        testingCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.goBusuniess(_:)), name: NSNotification.Name(rawValue: "GoBusiness"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateBusinessData(_:)), name: NSNotification.Name(rawValue: "RatingDataUpdate"), object: nil)
        
        //added observer to check for value change
        mapView.addObserver(self, forKeyPath: "annotationsToIgnore", options: [.new,.old], context: nil)
        
        let panGest = UIPanGestureRecognizer(target: self, action: #selector(mapViewRegionDidChangeFromUserInteraction))
        mapView.addGestureRecognizer(panGest)
        
        
        
    }
    
    
    
    @objc private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       // self.offerButton.isEnabled            = true
        //self.offerButton.isExclusiveTouch     = true
        //self.searchButton.isExclusiveTouch    = true
        //self.settingButton.isExclusiveTouch   = true
        self.mapView.tag                    = 222
        self.mapView.delegate               = self
        //CommonMethod.setPoint()
        if CommonMethod.businessRadius != currentRadius || CommonMethod.noOfBusiness != currentbusinessNo{
            
            currentRadius = CommonMethod.businessRadius
            currentbusinessNo = CommonMethod.noOfBusiness
            let coordinateString = String(format: "%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
            var param = [String: AnyObject]();
//            param[NASearchLocationApiKey] = [NABussinessNameKey : searchView.text?.isEmpty == true ? "" : searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
            if ( !calledOneTime ) {
                searchBusiness(param)
                calledOneTime = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //added observer to check for value change
        mapView.addObserver(self, forKeyPath: "annotationsToIgnore", options: [.new,.old], context: nil)
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(showAlert(_:)))
        mapView.addGestureRecognizer(gest)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.mapView.delegate = nil;
        self.mapView.removeObserver(self, forKeyPath: "annotationsToIgnore")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if searchView.isFirstResponder{
//
//            self.searchView.isHidden     = true
//            self.logoImageView.isHidden  = false
//            self.searchButton.isHidden   = false
//            searchView.resignFirstResponder()
//        }
//        self.latTextField.resignFirstResponder()
//        self.longTextField.resignFirstResponder()
    }
    
    // MARK: - MapView delegate
    //oberser function
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "annotationsToIgnore" && isEqual(NSKeyValueChangeKey.oldKey)) {
            self.mapView.doClustering()
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //Update the user location in map
        
        CommonMethod.currentLocation = userLocation.location!
        
        
        if intialBusinessData == false{
            
            
            mapView.centerCoordinate = userLocation.location!.coordinate
            // call this method only when come first time on this screen
            //hudManager.showProgressHud("", overlay: true)
            intialBusinessData = true
            
            // setting the region for map when user location update
            let center = CLLocationCoordinate2D(latitude: userLocation.location!.coordinate.latitude, longitude: userLocation.location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: NARegionDegree, longitudeDelta: NARegionDegree))
            self.mapView.setRegion(region, animated: true)
            
            // preparing the param for getting current user default business
            let coordinateString = String(format: "%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
            var param = [String: AnyObject]();
//            param[NASearchLocationApiKey] = [NABussinessNameKey : "", NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
            searchBusiness(param)
            
            let regionRadius = 600 // 400 in meters
            let coordinateRegion = MKCoordinateRegion( center: userLocation.coordinate, latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius) )
            self.mapView.setRegion( coordinateRegion, animated: true)
            
        }
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self){
            
            return nil
        }
        
        
        
        if annotation.isKind(of: OCAnnotation.self){
            
            
            // show the annotation view for clustering screen
            let reuseId = "ClusterView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            let ocAnnotation = annotation as! OCAnnotation
            if annotationView == nil{
                
                
                
                annotationView?.viewWithTag(988)?.removeFromSuperview()
                annotationView                      = MKAnnotationView(annotation: ocAnnotation, reuseIdentifier: reuseId)
                let annotationLabel                 = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                annotationLabel.backgroundColor     = UIColor.blue
                annotationLabel.textColor           = UIColor.white
                annotationLabel.text                = "\(ocAnnotation.annotationsInCluster().count)"
                annotationLabel.font                = UIFont.systemFont(ofSize: 20)
                annotationLabel.textAlignment       = NSTextAlignment.center
                annotationLabel.layer.masksToBounds = true
                annotationLabel.layer.cornerRadius  = 20.0
                annotationLabel.tag                 = 25
                annotationView?.addSubview(annotationLabel)
                annotationView?.isEnabled             = true
                annotationLabel.isUserInteractionEnabled = true
                annotationView?.frame               = annotationLabel.frame
                
            }else{
                
                let annotationLabel:UILabel = annotationView?.viewWithTag(25) as! UILabel
                annotationLabel.text        = "\(ocAnnotation.annotationsInCluster().count)"
            }
            return annotationView
            
        }else{
            
            if let newAnnotation : CalloutAnnotationProtocol = annotation as? CalloutAnnotationProtocol, newAnnotation.isMember(of: CalloutAnnotation.self){
                
                var annotationView: CalloutAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: newAnnotation.calloutType()) as? CalloutAnnotationView
                if annotationView == nil {
                    annotationView = CalloutAnnotationView.callout(withAnnotation: newAnnotation)
                }
                else {
                    annotationView!.annotation = newAnnotation
                }
                
                annotationView!.parentAnnotationView = self.selectedAnnotationView
                annotationView!.mapView = mapView
                self.mapView.bringSubviewToFront(annotationView!)
                // annotationView?.backgroundColor = UIColor.red
                return annotationView
                
            }else{
                let imageView                   = UIImageView(image: UIImage(named:"blue-bg"))
                
                imageView.tintColor = UIColor.blue
                let reuseId = "reuseid"
                let customAnnotation : MapCallout = annotation as! MapCallout
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if annotationView == nil{
                    
                    annotationView                  = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    
                    
                    
                    annotationView?.addSubview(imageView)
                    imageView.tag                   = 11
                    
                    
                    
                    
                    let annotationLabel               = UILabel(frame: CGRect(x: 0, y: 16, width: 20, height: 0))
                    annotationLabel.textColor         = UIColor.white
                    annotationLabel.text              =  self.getAnnotationTitle(customAnnotation.calloutData.note.title as! NSString)
                    annotationLabel.tag               = 99
                    annotationLabel.sizeToFit()
                    annotationLabel.adjustsFontSizeToFitWidth = false
                    annotationLabel.lineBreakMode = .byTruncatingTail
                    annotationView?.addSubview(annotationLabel)
                    annotationView?.frame          = annotationLabel.frame
                    var bgImageViewFrame :CGRect   = imageView.frame
                    bgImageViewFrame.size.width    = annotationLabel.frame.size.width + 20
                    imageView.frame                = bgImageViewFrame
                    annotationLabel.center.x       = imageView.center.x
                    annotationLabel.center.y       = imageView.center.y - 5
                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                }else{
                    //if ( customAnnotation.calloutData.note.businessHotSpot == 0 ) {
                    let annotationLabel:UILabel     = annotationView?.viewWithTag(99) as! UILabel
                    annotationLabel.text            = self.getAnnotationTitle(customAnnotation.calloutData.note.title as! NSString)
                    annotationLabel.sizeToFit()
                    let imageView:UIImageView      = (annotationView?.viewWithTag(11) as! UIImageView)
                    imageView.tintColor = UIColor.red
                    annotationView?.frame          = annotationLabel.frame
                    var bgImageViewFrame :CGRect   = imageView.frame
                    bgImageViewFrame.size.width    = annotationLabel.frame.size.width + 20
                    imageView.frame                = bgImageViewFrame
                    annotationLabel.center.x       = imageView.center.x
                    annotationLabel.center.y       = imageView.center.y - 5
                    
                    // }
                }
                
                
                if ( customAnnotation.calloutData.note.businessHotSpot == 1 ) {
                    if ( annotationView == nil ) {
                        imageView.tintColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 0.8)
                        let annotationLabelHeader               = UILabel(frame: CGRect(x: 8, y: 0, width: 0, height: 15))
                        annotationLabelHeader.textColor         = UIColor.blue
                        annotationLabelHeader.text              =  "Hot spot of the day"
                        annotationLabelHeader.tag               = 988
                        annotationLabelHeader.adjustsFontSizeToFitWidth = true
                        annotationView?.frame = annotationLabelHeader.frame
                        annotationLabelHeader.font = annotationLabelHeader.font.withSize(11)
                        annotationView?.viewWithTag(99)?.frame.origin.y += 2
                        annotationLabelHeader.sizeToFit()
                        annotationView?.addSubview(annotationLabelHeader)
                    } else {
                        let imageView:UIImageView      = (annotationView?.viewWithTag(11) as! UIImageView)
                        imageView.tintColor =  UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 0.8)
                        let annotationLabelHeader               = UILabel(frame: CGRect(x: 8, y: 0, width: 0, height: 15))
                        annotationLabelHeader.textColor         = UIColor.red
                        annotationLabelHeader.text              =  "Hot spot of the day"
                        annotationLabelHeader.tag               = 988
                        annotationLabelHeader.adjustsFontSizeToFitWidth = true
                        annotationView?.frame = annotationLabelHeader.frame
                        annotationLabelHeader.font = annotationLabelHeader.font.withSize(11)
                        annotationView?.viewWithTag(99)?.frame.origin.y += 2
                        annotationLabelHeader.sizeToFit()
                        annotationView?.addSubview(annotationLabelHeader)
                    }
                } else {
                    if ( annotationView == nil ) {
                        imageView.tintColor = UIColor.blue
                        
                        for subVi in (annotationView?.subviews)! {
                            if ( subVi.tag == 988 ) {
                                subVi.removeFromSuperview()
                            }
                        }
                        annotationView?.viewWithTag(99)?.frame.origin.y -= 2
                        
                    } else {
                        let imageView:UIImageView      = (annotationView?.viewWithTag(11) as! UIImageView)
                        imageView.tintColor =  UIColor.blue
                        
                        for subVi in (annotationView?.subviews)! {
                            if ( subVi.tag == 988 ) {
                                subVi.removeFromSuperview()
                            }
                        }
                        annotationView?.viewWithTag(99)?.frame.origin.y -= 2
                        
                    }
                }
                
                if self.selectedAnnotationView != nil{
                    
                    self.mapView.bringSubviewToFront(self.selectedAnnotationView!)
                }
                self.mapView.sendSubviewToBack(annotationView!)
                return annotationView
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation!.isKind(of: MKUserLocation.self){
            return
        }
        
        timerStand.invalidate()
        
        if view.annotation!.isKind(of: OCAnnotation.self){
            
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            let annotation = view.annotation as! OCAnnotation
            
            //let clusterListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ClusterViewController") as! ClusterViewController
            if Testing{
                
                //clusterListViewController.cluserListData  = CommonMethod.shortBusiness((annotation.annotationsInCluster() as? [MapCallout])!, currentLocation: CLLocation(latitude: testingCoordinate.latitude, longitude: testingCoordinate.longitude) , businesses: businesses)
               // clusterListViewController.currentLocation = CLLocation(latitude: testingCoordinate.latitude, longitude: testingCoordinate.longitude)
            }else{
                
                if ( mapView.userLocation.location == nil ) {
                    
                 //   clusterListViewController.cluserListData  = CommonMethod.shortBusiness((annotation.annotationsInCluster() as? [MapCallout])!, currentLocation: CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude), businesses: businesses)
                   // clusterListViewController.currentLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
                    
                } else {
                   // clusterListViewController.cluserListData  = CommonMethod.shortBusiness((annotation.annotationsInCluster() as? [MapCallout])!, currentLocation: mapView.userLocation.location!, businesses: businesses)
                  //  clusterListViewController.currentLocation = mapView.userLocation.location
                    
                }
                
                
                
            }
            
            //clusterListViewController.loginDetail            = self.loginDetail
           // clusterListViewController.backGroundImage         = CommonMethod.getScreenShotOfScreen(self.view)
           // self.navigationController?.pushViewController(clusterListViewController, animated: true)
            return
        }
        
        let annotation: MKAnnotation? = view.annotation
        if view.isSelected == false {
            return
        }
        if  let pinAnnotation: CalloutAnnotationProtocol = annotation as? CalloutAnnotationProtocol, annotation?.isKind(of: NoteCalloutViewController.self) == false {
            
            let mapBoundWidth : Float = Float(mapView.bounds.size.width)
            let mapRectWidth : Float = Float(mapView.visibleMapRect.size.width)
            currentZoomLevel = MKZoomScale(mapBoundWidth / mapRectWidth)
            if calloutAnnoation == nil {
                
                calloutAnnoation = CalloutAnnotation()
                calloutAnnoation!.copyAttributes(fromAnnotation: pinAnnotation)
                self.mapView.clusteringEnabled = false
                calloutAnnotationTitle = (annotation as! MapCallout).calloutData.note.title
                self.mapView.addAnnotation(calloutAnnoation!)
            }
            self.selectedAnnotationView = view
            self.mapView.bringSubviewToFront(self.selectedAnnotationView!)
            return
        }
        self.selectedAnnotationView = view
        mapView.setCenter(annotation!.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if view.annotation?.isKind(of: CalloutAnnotation.self) == true{
            return
        }
        
        if ((view.annotation as? CalloutAnnotationProtocol) != nil){
            
            if calloutAnnoation != nil {
                
                self.mapView.clusteringEnabled = true
                mapView.removeAnnotation(calloutAnnoation!)
                self.calloutAnnoation = nil
            }
        }else{
            return
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let mapBoundWidth : Float = Float(mapView.bounds.size.width)
        let mapRectWidth : Float = Float(mapView.visibleMapRect.size.width)
        currentZoomLevel = MKZoomScale(mapBoundWidth / mapRectWidth)
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        
    }
    
    
    /*func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
     print(oldCenter)
     print(mapView.centerCoordinate)
     
     
     
     //        let oldCoordinates = CLLocation(latitude: CLLocationDegrees(mapView.userLocation.coordinate.latitude), longitude: CLLocationDegrees(mapView.userLocation.coordinate.longitude))
     let newCoordindates = CLLocation(latitude:mapView.centerCoordinate.latitude, longitude:mapView.centerCoordinate.longitude)
     
     if ( oldCenter != nil  ) {
     let distanceInMeters = oldCenter.distance(from: newCoordindates)
     
     if ( distanceInMeters > 300000 ) {
     currentRadius = CommonMethod.businessRadius
     currentbusinessNo = CommonMethod.noOfBusiness
     let coordinateString = String(format: "%f,%f",mapView.centerCoordinate.latitude, mapView.centerCoordinate.latitude)
     var param = [String: AnyObject]();
     param[NASearchLocationApiKey] = [NABussinessNameKey : searchView.text?.isEmpty == true ? "" : searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
     searchBusiness(param)
     
     }
     }*/
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newCoordindates = CLLocation(latitude:mapView.centerCoordinate.latitude, longitude:mapView.centerCoordinate.longitude)
        
        //reclustering after certain zoom level
        let mapBoundWidth : Float = Float(mapView.bounds.size.width)
        let mapRectWidth : Float = Float(mapView.visibleMapRect.size.width)
        let mapZoomLevel : MKZoomScale = MKZoomScale(mapBoundWidth / mapRectWidth)
        if 0.05 > mapZoomLevel && MKZoomScale(round(10000 * self.currentZoomLevel!)/10000) != MKZoomScale(round(10000 * mapZoomLevel)/10000){
            self.mapView.clusteringEnabled = true
           // if calloutAnnoation != nil {
                
                self.mapView.clusteringEnabled = true
                mapView.deselectAnnotation(self.selectedAnnotation, animated: true)
           // }
        }
        if self.selectedAnnotationView != nil{
            
            self.mapView.sendSubviewToBack(self.selectedAnnotationView!)
            
        }
        self.mapView.doClustering()
        // reclustering after certain zoom level
        
        timerStand.invalidate()
        
        if ( oldCenter != nil && mapChangedFromUserInteraction  ) {
            let distanceInMeters = oldCenter.distance(from: newCoordindates)
            if ( distanceInMeters > 500 ) {
                
                
                timerStand = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block:  {(timer) in
                    
                    
                    
                    self.isSearchedFromMoving = true
                    self.currentRadius = CommonMethod.businessRadius
                    self.currentbusinessNo = CommonMethod.noOfBusiness
                    self.tapCoordinate = newCoordindates.coordinate
                    let coordinateString = String(format: "%f,%f",newCoordindates.coordinate.latitude, newCoordindates.coordinate.longitude)
                    var param = [String: AnyObject]();
//                    param[NASearchLocationApiKey] = [NABussinessNameKey : self.searchView.text?.isEmpty == true ? "" : self.searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
                   // self.searchBusiness(param,true)
                    
                    
                    
                })
                
                // timerStand.fire()
                
            }
        }
        //        oldCenter = newCoordindates
    }
    
    
    
    //    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    //
    //        let mapBoundWidth : Float = Float(mapView.bounds.size.width)
    //        let mapRectWidth : Float = Float(mapView.visibleMapRect.size.width)
    //        let mapZoomLevel : MKZoomScale = MKZoomScale(mapBoundWidth / mapRectWidth)
    //        if 0.05 > mapZoomLevel && MKZoomScale(round(10000 * self.currentZoomLevel!)/10000) != MKZoomScale(round(10000 * mapZoomLevel)/10000){
    //            self.mapView.clusteringEnabled = true
    //            if calloutAnnoation != nil {
    //
    //                self.mapView.clusteringEnabled = true
    //                mapView.deselectAnnotation(self.selectedAnnotation, animated: true)
    //            }
    //        }
    //        if self.selectedAnnotationView != nil{
    //
    //            self.mapView.sendSubview(toBack: self.selectedAnnotationView!)
    //
    //        }
    //        self.mapView.doClustering()
    //
    //
    //        }
    
    
    // MARK: - BusinessSelected PopUp delegate
    
    /*
     @description : This delegate method called when user select the business option from Custom BusinessOption Alert
     @parameter   : BusinessSelection type value(PlaceDetail, ShowDirection on map, BookUber)
     @return      : No
     */
    func businessSelected(_ business: BusinessSelection, businessDetail: BusinessDetail){
        
        if business == BusinessSelection.placeDetail{
            
//            let userRating = self.storyboard!.instantiateViewController(withIdentifier: "UserRatingViewController") as! UserRatingViewController
//            userRating.businessDetail = businessDetail
//            userRating.loginDetail    = self.loginDetail
//            let businessCoordinate : CLLocation = CLLocation(latitude: businessDetail.businessLatitude, longitude: businessDetail.businessLongitude)
//
//            if Testing == false{
//
//                let radius : CLLocationDistance = businessCoordinate.distance(from: CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
//
//                //Checking radius if user come under business radius then he will able to rate the business
//                if ((radius * 3.28084) <= NARatingRadius){
//                    userRating.isUserRate = true
//                }
//            }else{
//
//                userRating.isUserRate = true
//            }
//            self.navigationController!.pushViewController(userRating, animated: true)
            
        }else if business == BusinessSelection.showDirection{
            
            // Showing the direction on apple map from current location to destination address
            let endingCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(businessDetail.businessLatitude, businessDetail.businessLongitude)
            let endLocation     = MKPlacemark(coordinate: endingCoord, addressDictionary: nil)
            let endingItem      = MKMapItem(placemark: endLocation)
            let launchOptions   = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            endingItem.name     = businessDetail.businessName
            endingItem.openInMaps(launchOptions: launchOptions)
            
        }else{
            
            // showing the uber app if install in user phone else open web in safari for book the uber
            if (UIApplication.shared.canOpenURL(URL(string: NAUberAppURlString)!)) {
                
                UIApplication.shared.openURL(URL(string: NAUberAppURlString)!)
                
            }else {
                
                UIApplication.shared.openURL(URL(string: NAUberWebURLString)!)
            }
        }
    }
    
    // MARK: - UITextField delegate
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        //hudManager.showProgressHud("", overlay: true)
        
        var coordinateString : String?
        if Testing == false{
            
            coordinateString = String(format: "%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
        }
        else{
            
            //This commented code is only for QA testing uncomment it when you want to send build for QA
            coordinateString = String(format: "%f,%f",testingCoordinate.latitude, testingCoordinate.longitude)
        }
        
        var param = [String: AnyObject]();
        
//        param[NASearchLocationApiKey] = [NABussinessNameKey : self.searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
        searchBusiness(param)
    }
    
    // MARK: - IBAction method
    
    @IBAction func searchDoneAction(_ sender: UIBarButtonItem) {
        
        searchView.text            = nil
        self.searchView.isHidden     = true
        self.logoImageView.isHidden  = false
        self.searchButton.isHidden   = false
        searchView.resignFirstResponder()
    }
    
    /*
     @description : Call when user click on offer button for checking offer
     @parameter   : sender of type UIButton
     @return      : No
     */
    @IBAction func checkOfferAction(_ sender: UIButton) {
        
        sender.isEnabled = false
    }
    
    
    /*
     @description : We showing alert when user long press on mapview at any location then we are showing him/her a alert for 5 business for its near by location
     @parameter   : sender of type UILongPressGestureRecognizer
     @return      : No
     */
    @IBAction func showAlert(_ sender: UILongPressGestureRecognizer) {
        
        
        
        if tapCoordinate != nil{
            if ( !isSearchedFromMoving ) {
                return
            }
            return
        }
        
        let touchPoint                = sender.location(in: mapView)
        let touchMapCoordinate        = self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let coordinateString : String = String(format: "%f,%f", touchMapCoordinate.latitude, touchMapCoordinate.longitude)
        //  let coordinateString : String = String(format: "%f,%f", 33.6363591,-117.9338167)
        
        tapCoordinate = touchMapCoordinate
        
//        let alertController = SMHAlertController(title:"", message: String(format: "Would you like to see top %d near by location of this area?", CommonMethod.noOfBusiness!))
        
//        UIAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (success) -> Void in
//
//            var param = [String: AnyObject]();
//
//            param[NASearchLocationApiKey] = [NABussinessNameKey : self.searchView.text?.isEmpty == true ? "" : self.searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
//
//            self.searchBusiness(param)
//
//        }));
//
//        UIAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (success) -> Void in
//
//            self.tapCoordinate = nil
//        }));
//        UIAlertController.show()
    }
    
    /*
     @description : Showing the setting alert for business search
     @parameter   : sender of type UIButton
     @return      : No
     */
    @IBAction func settingButtonAction(_ sender: UIButton) {
        
       
    }
    
    /*
     @description : Showing the search bar instead of logo in map when user click on search button
     @parameter   : sender of type UIButton
     @return      : No
     */
    @IBAction func searchButtonAction(_ sender: UIButton) {
        
        sender.isHidden          = true
        settingButton.isEnabled  = true
        self.searchView.isHidden = false
        self.logoImageView.isHidden = true
        self.searchView.becomeFirstResponder()
    }
    
    /*
     @description : This method is only for QA Testing when user tester want to search any location from its given lat, long
     @parameter   : sender of type UIButton
     @return      : No
     */
    @IBAction func searchTesting(_ sender: UIButton) {
        
        self.latTextField.resignFirstResponder()
        self.longTextField.resignFirstResponder()
        intialBusinessData = true
        testingCoordinate = CLLocationCoordinate2DMake(Double(self.latTextField.text!)!, Double(self.longTextField.text!)!)
        let center = CLLocationCoordinate2D(latitude: testingCoordinate.latitude, longitude: testingCoordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: NARegionDegree, longitudeDelta: NARegionDegree))
        self.mapView.setRegion(region, animated: true)
        
        let coordinateString = String(format: "%f,%f",testingCoordinate.latitude, testingCoordinate.longitude)
        var param = [String: AnyObject]();
//        param[NASearchLocationApiKey] = [NABussinessNameKey : "", NABussinessLocationKey : coordinateString, NALoginEmailId : self.loginDetail.loginEmailID, NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as AnyObject
        searchBusiness(param)
    }
    
    
    // MARK: - Class Suport method
    
    func getAnnotationTitle(_ string : NSString)-> String{
        
        let myNSString = string as NSString
        
        // return string as! String
        
        var lastIndex = 15
        if myNSString.length <= 15{
            lastIndex = myNSString.length
            return myNSString.substring(with: NSRange(location: 0, length: lastIndex))
        }
        return (myNSString.substring(with: NSRange(location: 0, length: lastIndex))) + "..."
    }
    
    /*
     @description : This method update business data in main array
     @parameter   : notification of type NSNotification
     @return      : no
     */
    @objc func updateBusinessData(_ notification : Notification){
        
        let businessDetail = notification.userInfo!["business"] as! BusinessDetail
        for i in (0...self.businesses.count - 1){
            
            let business = self.businesses[i]
            if business.businessId == businessDetail.businessId{
                
                self.businesses.remove(at: i)
                self.businesses.insert(businessDetail, at: i)
            }
        }
    }
    
    /*
     @description : This method will search business from list with id and then show details of business
     @parameter   : notification of NSNotification
     @return      : no
     */
    @objc func goBusuniess(_ notification : Notification){
        
        timerStand.invalidate()
        
        DispatchQueue.main.async { () -> Void in
            
//            let businessDetail = self.businesses.filter{ $0.businessId == notification.userInfo![NABusinessIdKey] as! String}.first
//            let userRating = self.storyboard!.instantiateViewController(withIdentifier: "UserRatingViewController") as! UserRatingViewController
//            userRating.businessDetail  = businessDetail
//            userRating.loginDetail     = self.loginDetail
//            userRating.backgroundImage = CommonMethod.getScreenShotOfScreen(self.view)
//            let businessCoordinate : CLLocation = CLLocation(latitude: businessDetail!.businessLatitude, longitude: businessDetail!.businessLongitude)
//
//
//            if Testing == false{
//
//                let radius : CLLocationDistance = businessCoordinate.distance(from: CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude))
//                if ((radius * 3.28084) <= NARatingRadius){
//                    userRating.isUserRate = true
//                }
//            }else{
//
//                userRating.isUserRate = true
//            }
//            self.navigationController!.pushViewController(userRating, animated: true)
        }
    }
    
    /*
     @description : This method calculate the zoom level for fit all annotation on map area
     @parameter   : mapView of type MKMapView
     @return      : no
     */
    func zoomToFitAnnotation(_ mapView : MKMapView, withCenterCoordinate: CLLocationCoordinate2D){
        
        if mapView.annotations.count == 0 {
            return
        }
        let degree = 1.1
        if self.tapCoordinate != nil{
            self.tapCoordinate = nil
        }
        
        var topLeftCoord = CLLocationCoordinate2D(latitude:-90, longitude:120)
        var bottomRightCoord = CLLocationCoordinate2D(latitude:90, longitude:-120)
        
        for annotation: MKAnnotation in mapView.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        //        let coordinateSpan = MKCoordinateSpan(latitudeDelta: fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * degree, longitudeDelta: fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * degree) //old
        
        let miles = 5.0
        let scalingFactor = abs(cos(2*M_PI * withCenterCoordinate.latitude / 360.0))
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: miles/90.0, longitudeDelta:miles/(miles/90.0) )
        var region = MKCoordinateRegion(center: withCenterCoordinate, span: coordinateSpan)
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    /*
     @description : This method call server for business when user want to search any business or want to know business from its current location
     @parameter   : param of type Dic
     @return      : No
     */
    func searchBusiness(_ param:[String:AnyObject],_ isSearchedFrom: Bool = false){
        
       // hudManager.showProgressHud("Loading bussiness...", overlay: true)
        self.isSearchedFromMoving = isSearchedFrom
        
        if let path = Bundle.main.path(forResource: "new", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                if let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                    print(jsonResult)
                    
                    let res = jsonResult["business"] as? [Dictionary<String , AnyObject>]
                    let _ = BusinessDetail.parseBusinessData(res!, completionBlock: {(finishes,data) in
                        print(data)
                    
                    //let data = jsonResult["business"] as! Array
                    DispatchQueue.main.async(execute: { () -> Void in
            
                            var annotations = [MKAnnotation]()
                            var Tannotations = NSMutableSet()
                            var hotSpotBusiness : Note!
                            self.intialBusinessData = true
            
                            //hudManager.hideHud()
                            if true == true{
            
                                let businessDetailArray : [BusinessDetail] = (data as? Array)!
                                self.businesses = businessDetailArray
                                for items in businessDetailArray{
            
                                   let business = items
            
                                    business.businessDistance =  CommonMethod.currentLocation.distance(from: CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)) / Double(NAMeterInRadius)
            
                                    let recentRateTime = business.businessRecentRating.busy == 0  ? "" : "" //CommonMethod.getTime(business.businessRecentRating.ratingTime!)
                                    let offerTime      = business.offer?.offerID == 0 ? "" :""//CommonMethod.getOfferTime(business.offer!.offerStartDate, endTime: business.offer!.offerEndDate)
                                    let note1       = Note(title: business.businessName, businessID: business.businessId,  businessAddress: business.businessAddress, businessDistance:String(format: "%0.2f",CommonMethod.currentLocation.distance(from: CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)) / Double(NAMeterInRadius)), profileImg: business.businessImageUrl, businessTerm: business.businessTerm, offerName: business.offer!.offerName, offerTime: offerTime, avgBusy: business.businessAvgRating.busy!, avgSeating: business.businessAvgRating.seating!, avgMF: business.businessAvgRating.femaleMaleRatio!, avgHotness: business.businessAvgRating.hotness!, recentRateName: business.businessRecentRating.userName!, recentRateTime: recentRateTime, recentRateBadge: business.businessRecentRating.badgePoint!, recentRateBusy: business.businessRecentRating.busy!, recentRateSeating: business.businessRecentRating.seating!, recentRateMF: business.businessRecentRating.femaleMaleRatio!, recentRateHotness: business.businessRecentRating.hotness!, businessCity:business.businessCity!,businessHotSpot:business.hotSpot!)
            
            
            
                                    let noteCall    = NoteCallout(note: note1)
            
                                    if let mapCallout  = MapCallout(coordinate: CLLocationCoordinate2DMake(business.businessLatitude, business.businessLongitude), data: noteCall){
                                        annotations.append(mapCallout)
            
                                        //exluding those annotation which we dont want to get clustered
                                        if ( business.hotSpot == 1 ) {
                                            Tannotations.add(mapCallout)
                                            hotSpotBusiness = note1
                                        } else {
                                            //                                let ReportAnnotation = MKPointAnnotation()
                                            //                                ReportAnnotation.title = "Annotation Created"
                                            //                                ReportAnnotation.subtitle = ""
                                            //                                ReportAnnotation.coordinate =  CLLocationCoordinate2DMake(business.businessLatitude, business.businessLongitude)
                                            //
                                            //                                 let x = MKPinAnnotationView(annotation: ReportAnnotation, reuseIdentifier: "pp") as? MKPinAnnotationView
                                            //
                                            //                                self.mapView.addAnnotation(x!.annotation!)
            
            
            
                                        }
            
            
                                    }
                                }
                            }else{
            
                               // CommonMethod.showToste("We are not finding any business for your location!", controller: self)
                                //self.tapCoordinate = nil
                            }
                            self.tapCoordinate = nil
                            //self.mapView.clusteringEnabled = false
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            self.mapView.addAnnotations(annotations)
                            self.mapView.annotationsToIgnore = Tannotations
                            // if there is a business then check if it's come in business radius then show the alert for see the business detail
            
            
                            if annotations.count >= 1{
            
                                self.timerStand.invalidate()
            
                                if ( self.isSearchedFromMoving  ) {
                                    let regionRadius = 600 // 400 in meters
                                    //                        let coordinateRegion = MKCoordinateRegionMakeWithDistance( self.tapCoordinate!, CLLocationDistance(regionRadius), CLLocationDistance(regionRadius) )
                                    self.mapView.setRegion( self.mapView.region, animated: true)
            
                                }
            
            
                                if ( self.intialBusinessData == true ) {
            
            
                                    if self.tapCoordinate != nil{
                                        if (!self.isSearchedFromMoving){
                                            // self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.tapCoordinate!)
                                        }
            
                                    }else if self.testingCoordinate.latitude != 0{
                                        if (!self.isSearchedFromMoving){
                                            //self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.testingCoordinate)
                                        }
            
                                    }else{
                                        if (!self.isSearchedFromMoving){
                                            // self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.mapView.userLocation.coordinate)
                                        }
                                    }
            
                                } else {
                                    self.timerStand.invalidate()
                                }
                                self.intialBusinessData = true
                                // self.isSearchedFromMoving = false
                                self.oldCenter = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
            
                                if ( hotSpotBusiness == nil ) {
                                    if ( self.intialBusinessData ) {
                                        //self.showNewBussinessAlert()
                                    }
                                } else {
                                    if ( self.intialBusinessData ) {
                                        //self.showHotSpotPopUp(note:hotSpotBusiness)
                                    }
                                }
                            }
            
                        })
                        })
                    };
                

            } catch{}
        
        }
        
        
//        ServiceManager.callApi(param, api: ServiceApi.searchLocationApi) { (success, data) -> () in
//
//            DispatchQueue.main.async(execute: { () -> Void in
//
//                var annotations = [MKAnnotation]()
//                var Tannotations = NSMutableSet()
//                var hotSpotBusiness : Note!
//                self.intialBusinessData = true
//
//                hudManager.hideHud()
//                if success == true{
//
//                    let businessDetailArray : [BusinessDetail] = (data as? Array)!
//                    self.businesses = businessDetailArray
//                    for i in (0...businessDetailArray.count - 1){
//
//                        let business : BusinessDetail = businessDetailArray[i]
//
//                        business.businessDistance =  CommonMethod.currentLocation.distance(from: CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)) / Double(NAMeterInRadius)
//
//                        let recentRateTime = business.businessRecentRating.busy == 0  ? "" : CommonMethod.getTime(business.businessRecentRating.ratingTime!)
//                        let offerTime      = business.offer?.offerID == 0 ? "" :CommonMethod.getOfferTime(business.offer!.offerStartDate, endTime: business.offer!.offerEndDate)
//                        let note1       = Note(title: business.businessName, businessID: business.businessId,  businessAddress: business.businessAddress, businessDistance:String(format: "%0.2f",CommonMethod.currentLocation.distance(from: CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)) / Double(NAMeterInRadius)), profileImg: business.businessImageUrl, businessTerm: business.businessTerm, offerName: business.offer!.offerName, offerTime: offerTime, avgBusy: business.businessAvgRating.busy!, avgSeating: business.businessAvgRating.seating!, avgMF: business.businessAvgRating.femaleMaleRatio!, avgHotness: business.businessAvgRating.hotness!, recentRateName: business.businessRecentRating.userName!, recentRateTime: recentRateTime, recentRateBadge: business.businessRecentRating.badgePoint!, recentRateBusy: business.businessRecentRating.busy!, recentRateSeating: business.businessRecentRating.seating!, recentRateMF: business.businessRecentRating.femaleMaleRatio!, recentRateHotness: business.businessRecentRating.hotness!, businessCity:business.businessCity!,businessHotSpot:business.hotSpot!)
//
//
//
//                        let noteCall    = NoteCallout(note: note1)
//
//                        if let mapCallout  = MapCallout(coordinate: CLLocationCoordinate2DMake(business.businessLatitude, business.businessLongitude), data: noteCall){
//                            annotations.append(mapCallout)
//
//                            //exluding those annotation which we dont want to get clustered
//                            if ( business.hotSpot == 1 ) {
//                                Tannotations.add(mapCallout)
//                                hotSpotBusiness = note1
//                            } else {
//                                //                                let ReportAnnotation = MKPointAnnotation()
//                                //                                ReportAnnotation.title = "Annotation Created"
//                                //                                ReportAnnotation.subtitle = ""
//                                //                                ReportAnnotation.coordinate =  CLLocationCoordinate2DMake(business.businessLatitude, business.businessLongitude)
//                                //
//                                //                                 let x = MKPinAnnotationView(annotation: ReportAnnotation, reuseIdentifier: "pp") as? MKPinAnnotationView
//                                //
//                                //                                self.mapView.addAnnotation(x!.annotation!)
//
//
//
//                            }
//
//
//                        }
//                    }
//                }else{
//
//                    CommonMethod.showToste("We are not finding any business for your location!", controller: self)
//                    //self.tapCoordinate = nil
//                }
//                self.tapCoordinate = nil
//                //self.mapView.clusteringEnabled = false
//                self.mapView.removeAnnotations(self.mapView.annotations)
//                self.mapView.addAnnotations(annotations)
//                self.mapView.annotationsToIgnore = Tannotations
//                // if there is a business then check if it's come in business radius then show the alert for see the business detail
//
//
//                if annotations.count >= 1{
//
//                    self.timerStand.invalidate()
//
//                    if ( self.isSearchedFromMoving  ) {
//                        let regionRadius = 600 // 400 in meters
//                        //                        let coordinateRegion = MKCoordinateRegionMakeWithDistance( self.tapCoordinate!, CLLocationDistance(regionRadius), CLLocationDistance(regionRadius) )
//                        self.mapView.setRegion( self.mapView.region, animated: true)
//
//                    }
//
//
//                    if ( self.intialBusinessData == true ) {
//
//
//                        if self.tapCoordinate != nil{
//                            if (!self.isSearchedFromMoving){
//                                // self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.tapCoordinate!)
//                            }
//
//                        }else if self.testingCoordinate.latitude != 0{
//                            if (!self.isSearchedFromMoving){
//                                //self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.testingCoordinate)
//                            }
//
//                        }else{
//                            if (!self.isSearchedFromMoving){
//                                // self.zoomToFitAnnotation(self.mapView,withCenterCoordinate: self.mapView.userLocation.coordinate)
//                            }
//                        }
//
//                    } else {
//                        self.timerStand.invalidate()
//                    }
//                    self.intialBusinessData = true
//                    // self.isSearchedFromMoving = false
//                    self.oldCenter = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
//
//                    if ( hotSpotBusiness == nil ) {
//                        if ( self.intialBusinessData ) {
//                            self.showNewBussinessAlert()
//                        }
//                    } else {
//                        if ( self.intialBusinessData ) {
//                            self.showHotSpotPopUp(note:hotSpotBusiness)
//                        }
//                    }
//                }
//
//            })
//        };
        
    }
    
    
    
    
    
    /*
     @description : This method will check if is there any business near by user in 100 meter radius then show the alert
     @parameter   : No
     @return      : No
     */
    func showNewBussinessAlert(){
        
        var nearBusiness = [BusinessDetail]()
        
        for index in (0...businesses.count - 1){
            
            let business = businesses[index] as BusinessDetail
            let businessCoordinate : CLLocation = CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)
            
            
            if Testing == false{
                
                let radius : CLLocationDistance = businessCoordinate.distance(from: CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
                if ((radius * 3.28084) <= NARatingRadius){
                    nearBusiness.append(business)
                }
            }
            self.selectedBusinessDetail = business
            
        }
        
        if nearBusiness.count > 0{
            
            timerStand.invalidate()
            
            let nearByAlert = self.storyboard?.instantiateViewController(withIdentifier: "BusinessNearPopUpViewController") as! BusinessNearPopUpViewController
            nearByAlert.nearByBusiness          = nearBusiness
            nearByAlert.myStoryboard            = self.storyboard
            nearByAlert.navController           = self.navigationController
            nearByAlert.modalPresentationStyle  = UIModalPresentationStyle.overCurrentContext
            nearByAlert.modalTransitionStyle    = UIModalTransitionStyle.crossDissolve
            
            if (self.presentedViewController != nil) {
                self.dismiss(animated: true) { () -> Void in
                    
                    self.present(nearByAlert, animated: true) { () -> Void in }
                }
            }else{
                
                self.present(nearByAlert, animated: true) { () -> Void in }
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == NAOfferSeguename){
            
          //  let offerController         = segue.destination as! OffersViewController
           // offerController.loginDetail = self.loginDetail
        }
    }
    
    @IBAction func recenterButtonAction(_ sender: Any) {
        timerStand.invalidate()
        
        // mapView.removeAnnotations(mapView.annotations)
        
        if ( mapView.annotationsToIgnore.count > 0 ) {
            mapView.annotationsToIgnore.removeAllObjects()
        }
        mapView.removeAnnotations(mapView.annotations)
        
        
        currentRadius = CommonMethod.businessRadius
        currentbusinessNo = CommonMethod.noOfBusiness
        let coordinateString = String(format: "%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
        var param = [String: AnyObject]();
//        param[NASearchLocationApiKey] = [NABussinessNameKey : searchView.text?.isEmpty == true ? "" : searchView.text, NABussinessLocationKey : coordinateString, NALoginEmailId : , NASearchBusinessNoKey : String(format: "%d", CommonMethod.noOfBusiness!), NASearchLimitKey : String(format: "%f",Float(CommonMethod.businessRadius!)  * NAMeterInRadius)] as! AnyObject
        searchBusiness(param,true)
        
        
        let regionRadius = 600 // 400 in meters
        let coordinateRegion = MKCoordinateRegion( center: mapView.userLocation.coordinate, latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius) )
        self.mapView.setRegion( coordinateRegion, animated: true)
        
        
        
        
    }
    
    
    
    
    func showHotSpotPopUp(note : Note){
        timerStand.invalidate()
        let view = HotSpotView()
        view.frame = self.view.frame
        
        let btnCancel = UIButton()
        btnCancel.frame = CGRect(x: self.view.frame.width - (16 + 50), y: 30, width: 50, height: 50)
        btnCancel.setTitle("X", for: .normal)
        btnCancel.setTitleColor(UIColor.white, for: .normal)
        btnCancel.backgroundColor = UIColor.red
        btnCancel.layer.cornerRadius = 25
        btnCancel.addTarget(self, action: #selector(cancelHotSpotView(_:)), for:  .touchUpInside  )
        view.addSubview(btnCancel)
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        view.note = note
        view.contentView.frame = CGRect(x:8,y:self.view.frame.height/2 - 100,width:self.view.frame.width - 16,height:184)
        view.contentView.layer.cornerRadius = 5
        
        view.contentView.frame.size.height = 120
        view.contentView.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 0.8)
        view.tag = 8564
        self.view.addSubview(view)
    }
    
    @objc func cancelHotSpotView(_ sender:UIButton) {
        self.view.viewWithTag(8564)?.removeFromSuperview()
        self.showNewBussinessAlert()
    }
    
    
    
    
    
}
