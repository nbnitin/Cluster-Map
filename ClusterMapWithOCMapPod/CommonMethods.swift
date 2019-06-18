//
//  CommonMethods.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 16/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit
import MapKit
//import Lottie
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let CommonMethod = CommonMethods.sharedInstance
let Testing = false

class CommonMethods: NSObject {
    
//    private static var __once: () = {
//            Static.instance = CommonMethods()
//        }()
    
    static let sharedInstance = CommonMethods()

    
    //var tostController:SMHAlertController?
    var offerPageIndex : Int?
    var isNextPage : Bool?
    var noOfBusiness : Int?
    var businessRadius : Int?
    var currentUserBadge : Int?
    var appLaunchByBadgePush : Bool?
    var screenCounter : Int?
    var showBadgeAlert : [String : AnyObject]?
    var count = 0
    lazy var currentLocation : CLLocation = {
        
        return CLLocation(latitude: 0, longitude: 0)
    }()
    
//    class var sharedInstance: CommonMethods {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: CommonMethods? = nil
//        }
//        _ = CommonMethods.__once
//        return Static.instance!
//    }
    
    func showToste(_ message: String, controller: UIViewController){
        
        DispatchQueue.main.async { () -> Void in
            
//            self.tostController = SMHAlertController(title: "", message: message)
//            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            self.tostController?.addAction(alertAction)
//            self.tostController!.show()
        }
    }
    
//    func showSuccess(){
//        print("by bye11 \(self.count)")
//        
//        
//        
//
//        //DispatchQueue.main.async { () -> Void in
//            let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        
//        if let x = app.window?.viewWithTag(9999){
//           
//            x.removeFromSuperview()
//        }
//        
//        if let x = app.window?.viewWithTag(8888){
//            
//            x.removeFromSuperview()
//        }
//        
//            
//        var vi : UIView? = UIView(frame:CGRect(x:0,y:0,width:120,height:120))
//        vi?.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
//        vi?.layer.cornerRadius = 10
//        vi?.center = ((app.window?.center)!)
//        app.window?.addSubview((vi)!)
//        let animationView = AnimationView(name: "1127-success")
//        animationView.frame = CGRect(x:0,y:0,width:100,height:100)
//        animationView.center = ((app.window?.center)!)
//        animationView.clipsToBounds = true
//        
//                   // animationView.contentMode = .scaleAspectFill
//                    animationView.tag = 9999
//        vi?.tag = 8888
//        
//                    app.window?.addSubview(animationView)
//        
//
//                        animationView.play { (finished)->Void in
//                            if (finished){
//                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: { () -> Void in
//                                    UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//                                        vi?.alpha = 0.0
//                                        vi?.removeFromSuperview()
//                                        vi = nil
//                                        animationView.removeFromSuperview()
//                                        
//                                    })
//                                })
//                            }
//
//
//                    }
//        
////        var vi :UIView? = UIView(frame:CGRect(x:0,y:0,width:100,height:100))
////        vi?.backgroundColor = UIColor.red
////        vi?.tag = 9999
////        app.window?.addSubview((vi)!)
////        vi?.alpha = 1
////    //vi.addSubview(animationView)
////
////            // Applying UIView animation
////            let minimizeTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
////        vi?.transform = minimizeTransform
////            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
////                vi?.transform = CGAffineTransform.identity
////                self.count += 1
////            }, completion:{ _ in
////                vi?.removeFromSuperview()
////                print("by bye \(self.count)")
////                vi?.alpha = 0
////                vi = nil
////            })
////                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0), execute: { () -> Void in
////                    UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
////                        vi.alpha = 0.0
////
////                    })
////                })
//           // }
//       // }
//    }
//    
    func getTextHeight(_ reviewText: String, fontSize: CGFloat) -> CGFloat{
        
        let textLabel           = UILabel(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 26, height: 10))
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;
        textLabel.font          = UIFont.systemFont(ofSize: fontSize)
        textLabel.text          = reviewText
        let requoredSize        = textLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 26, height: 1000))
        return requoredSize.height;
    }
    
//    func saveFile(_ imageUrl: String, completionBlock: @escaping (_ image: UIImage?) -> ()){
//
//        let fileManager         = FileManager.default
//        let nsUrl               = URL(string: imageUrl)
//        let searchPath          = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let dirPath       = searchPath.appendingPathComponent("should_i_go")
//        if let _ = nsUrl?.pathComponents{
//
////        if let dirPath = directoryPath {
//
//            if (fileManager.fileExists(atPath: dirPath.path) == false){
//                try! fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
//            }
//            let pathComponents :[String] = (nsUrl?.pathComponents)!
//            let secondLastPath           = pathComponents[pathComponents.count - 2]
//            let lastPath                 = pathComponents[pathComponents.count - 1]
//
//
//            let filePath            = dirPath.appendingPathComponent(String(format:"%@_%@", secondLastPath, lastPath))
//        if  (fileManager.fileExists(atPath: filePath.path) == false){
//
//                ServiceManager.downloadSourceImage(imageUrl) { (success, image) -> () in
//
//                    if success == true{
//
//                        let written = (try? UIImagePNGRepresentation(image!)!.write(to: filePath, options: [.atomic])) != nil
//                        Logs.statementLog("\(written)")
//                        completionBlock(image)
//                    }
//                    else{
//
//                        completionBlock(UIImage(named: "default_img.png"))
//                    }
//                }
//
//            }else{
//
////                if let imagePath = filePath {
//
//                    let image = UIImage(contentsOfFile: filePath.path)
//            completionBlock(image)
////                }
//            }
////        }
//        } else {
//            completionBlock(UIImage(named: "default_img.png"))
//        }
//    }
    
//    func clearDocumentDirectory(){
//
//        let fileManager         = FileManager.default
//        let searchPath          = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let dirPath       = searchPath.appendingPathComponent("")
//
////        if let dirPath = directoryPath {
//
//            if fileManager.fileExists(atPath: dirPath.path){
//
//                let fileInFolder = try! fileManager.contentsOfDirectory(atPath: dirPath.path)
//                for filePath in fileInFolder {
//
//                    let imagePath = ((dirPath.path) + "/\(filePath)")
//                    if fileManager.fileExists(atPath: imagePath){
//
//                        try! fileManager.removeItem(atPath: imagePath)
//                    }
//                }
//            }
////        }
//    }
    
    func shortBusiness(_ businessesAnnotation : [MapCallout], currentLocation : CLLocation, businesses: [BusinessDetail]) -> [BusinessDetail]{
        
        var annotations = [BusinessDetail]()
        
        for index in (0...businessesAnnotation.count - 1){
            
            let annotation : MapCallout = businessesAnnotation[index] as MapCallout
            let businessDetail = businesses.filter{ $0.businessId == annotation.calloutData.note.businessId}.first
            businessDetail!.businessDistance =  currentLocation.distance(from: CLLocation(latitude: businessDetail!.businessLatitude, longitude: businessDetail!.businessLongitude)) / Double(NAMeterInRadius)
            annotations.append(businessDetail!)
        }
        annotations.sort{$0.businessDistance < $1.businessDistance}
        return annotations
    }
//
//    func getTime(_ fromString : String) -> String{
//
//        let dateFormater        = DateFormatter()
//        dateFormater.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        let dateObj             = Date()
//        let sourceTimeZone      = TimeZone(abbreviation: "GMT")
//        let systemTimeZone      = TimeZone.current
//
//        var highestRateDay : String = ""
//
//        if fromString != "0000-00-00 00:00:00" && fromString != ""{
//
//            let date                 = dateFormater.date(from: fromString)
//            let sourceGMTOffset      = sourceTimeZone?.secondsFromGMT(for: date!)
//            let destinationGMTOffset = systemTimeZone.secondsFromGMT(for: date!)
//            let interval             = destinationGMTOffset - sourceGMTOffset!
//            let destinationDate      = Date(timeInterval: TimeInterval(interval), since: date!)
//            highestRateDay = "/" + dateObj.offsetFrom(destinationDate) + " ago"
//        }
//        return highestRateDay
//    }
//
//    func getOfferTime(_ startTime : String, endTime : String) -> String{
//
//        let dateFormater        = DateFormatter()
//        dateFormater.dateFormat = "YYYY-MM-dd HH:mm"
//        let sourceTimeZone      = TimeZone(abbreviation: "GMT")
//        let systemTimeZone      = TimeZone.current
//
//        var highestRateDay : String = ""
//
//        if startTime != "0000-00-00 00:00" && startTime != ""{
//
//            let endDate                 = dateFormater.date(from: endTime)
//            let endGMTOffset            = sourceTimeZone?.secondsFromGMT(for: endDate!)
//            let destinatonEndGMTOffset  = systemTimeZone.secondsFromGMT(for: endDate!)
//            let interval                = destinatonEndGMTOffset - endGMTOffset!
//            let endDesDate              = Date(timeInterval: TimeInterval(interval), since: endDate!)
//            highestRateDay              = endDesDate.offsetFrom(Date())
//
//            if highestRateDay.hasSuffix("y"){
//
//                highestRateDay = highestRateDay.replacingOccurrences(of: "y", with: " year")
//            }else if highestRateDay.hasSuffix("m"){
//                highestRateDay = highestRateDay.replacingOccurrences(of: "m", with: " months")
//            }else if highestRateDay.hasSuffix("d"){
//                highestRateDay = highestRateDay.replacingOccurrences(of: "d", with: " days")
//            }else if highestRateDay.hasSuffix("hr"){
//                highestRateDay = highestRateDay.replacingOccurrences(of: "hr", with: " hours")
//            }else if highestRateDay.hasSuffix("min"){
//                highestRateDay = highestRateDay.replacingOccurrences(of: "min", with: " minutes")
//            }
//        }
//        return highestRateDay
//    }
//
    
    
    func changeButtonsBgColor(_ buttonState: Bool, button: UIButton){
        
        if buttonState == false{
            
            //button.backgroundColor = UIColor(colorLiteralRed: 218 / 255.0, green: 218 / 255.0, blue: 218 / 255.0, alpha: 1)
        }else{
            
           // button.backgroundColor = UIColor(colorLiteralRed: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
        }
    }
    
    func getBadgeImage(_ badgePoint : Int) -> UIImage{
        
        var image : UIImage? = nil
        switch badgePoint{
            
        case 0...5:
            image = UIImage(named: "privateV.png")
            break
        case 6...10:
            image = UIImage(named: "privatefirstclass.png")
            break
        case 11...15:
            image = UIImage(named: "corporal.png")
            break
        case 16...20:
            image = UIImage(named: "sergant.png")
            break
        case 21...25:
            image = UIImage(named: "staffsergeant.png")
            break
        case 26...30:
            image = UIImage(named: "sergeantfirstclass.png")
            break
        case 31...35:
            image = UIImage(named: "mastersergeant.png")
            break
        case 36...40:
            image = UIImage(named: "firstsergeant.png")
            break
        case 41...45:
            image = UIImage(named: "sergeantmajor.png")
            break
        case 46...50:
            image = UIImage(named: "commandsergeantmajor.png")
            break
        case 51...55:
            image = UIImage(named: "2ndlieutant.png")
            break
        case 56...60:
            image = UIImage(named: "1stlieutant.png")
            break
        case 61...65:
            image = UIImage(named: "captain.png")
            break
        case 66...70:
            image = UIImage(named: "major.png")
            break
        case 71...75:
            image = UIImage(named: "lieutenancolonel.png")
            break
        case 76...80:
            image = UIImage(named: "brigadiergeneral.png")
            break
        case 81...85:
            image = UIImage(named: "majorgeneral.png")
            break
        case 86...90:
            image = UIImage(named:"lieutenantgeneral.png")
        case 90...95:
            image = UIImage(named: "general.png")
            break
        case 96...100:
            image = UIImage(named: "generalofthelocation.png")
            break
        
        default:
            image = UIImage(named: "generalofthelocation.png")
        }
        return image!
        
    }
    
    func getBadgeName(_ badgePoint : Int) -> String{
        
        var badgeName : String? = nil
        switch badgePoint{
            
        case 0...4:
            badgeName = "Beer Taster"
            break
        case 5...10:
            badgeName = "Beer Chugger"
            break
        case 11...18:
            badgeName = "Wine Sipper"
            break
        case 19...25:
            badgeName = "Wine Connoisseur"
            break
        case 26...35:
            badgeName = "House Margarita"
            break
        case 36...45:
            badgeName = "Cadilac Margarita"
            break
        case 46...57:
            badgeName = "Straight Up Martini"
            break
        case 58...70:
            badgeName = "Dirty Martini"
            break
        case 71...86:
            badgeName = "Single Shot"
            break
        default:
            badgeName = "Shot Caller"
        }
        return badgeName!
        
    }
    
    
    func setRatioButtonImage(_ ratio: Int) -> UIImage{
        
        if ratio == 1{
            return UIImage(named: "red_selected.png")!
        }else if ratio == 2{
            return UIImage(named: "yellow_selected.png")!
        }else if ratio == 3{
            return UIImage(named: "green_selected.png")!
        }else{
            return UIImage(named: "red_unselected.png")!
        }
    }
    
    func setMaleFemaleImage(_ ratio: Int) -> UIImage{
        
        if ratio == 1{
            return UIImage(named: "male.png")!
        }else if ratio == 2{
            return UIImage(named: "equal.png")!
        }else if ratio == 3{
            return UIImage(named: "female.png")!
        }
        return UIImage(named: "equal.png")!
    }
    
    func setMaleFemaleBlackImage(_ ratio: Int) -> UIImage{
        
        if ratio == 1{
            return UIImage(named: "male_black.png")!
        }else if ratio == 2{
            return UIImage(named: "mal_female_black.png")!
        }else if ratio == 3{
            return UIImage(named: "female_black.png")!
        }
        return UIImage(named: "mal_female_black.png")!
    }
    
    /**
     @description : Showing new badge alert
     @parameter   : badge Dic for getting badge point from it
     @return      : no
     */
    func showBadgeAlert(_ badgeDic : [String : AnyObject]){
        
//        let badgeString = CommonMethod.getBadgeName((badgeDic["points"]?.intValue)!)
//        let attrString  = NSMutableAttributedString(string: String(format: "\n\nCongratulations! You are now a \"%@\"", badgeString))
//        attrString.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)], range: NSMakeRange(attrString.length - badgeString.characters.count, badgeString.characters.count))
//
//        let alert: SMHAlertController   = SMHAlertController(title:"", message: "")
//
//        alert.setValue(attrString, forKey: "attributedMessage")
//
//        let okAction: UIAlertAction     = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//        let badgeImageView      = UIImageView(frame: CGRect(x: 110, y: 10, width: 50, height: 50))
//        badgeImageView.image    = CommonMethod.getBadgeImage((badgeDic["points"]?.intValue)!)
//        badgeImageView.center.x = alert.view.center.x - 25
//        alert.view.addSubview(badgeImageView)
//        alert.addAction(okAction)
//        alert.show()
    }
    
    func getScreenShotOfScreen(_ view : UIView) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
   
    func isValidEmail(_ testStr:String) -> Bool {
        
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest   = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    
}


