//
//  Extensions.swift
//  WS-Connector
//
//  Created by QACG MAC2 on 8/23/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Foundation
import CoreGraphics
import UIKit
typealias  JSONObject = [String : AnyObject]
typealias JSONDictionary = [String: Any]
typealias JsonArray = Array<[String: Any]>
extension Int {
    var array: [Int] {
        return description.characters.map{Int(String($0)) ?? 0}
    }
    //Para SLCAlertView
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
    /// Rounds the double to decimal places value
    func redondearDecimales(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}

extension Float {
    
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
    
    
    
}

extension Dictionary{
    func getJsonAsset(name: String) -> JSONObject {
        let file = Bundle.main.path(forResource: name, ofType: "json")
        let url = URL(fileURLWithPath: file!)
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data)
        // print(json)
        return json as! JSONObject
    }
}

extension NSDictionary {
    func loadJson(forFilename fileName: String) -> NSDictionary? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                    
                    return dictionary
                } catch {
                    //  print("Error!! Unable to parse  \(fileName).json")
                }
            }
            //  print("Error!! Unable to load  \(fileName).json")
        }
        
        return nil
    }
}



extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    var length: Int { return characters.count    }  // Swift 3.0
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var numbers: String { return components(separatedBy: Numbers.characterSet.inverted).joined() }
    var integer: Int { return Int(numbers) ?? 0 }
    
    //separa las palabras
    func words(with charset: CharacterSet = .alphanumerics) -> [String] {
        return self.unicodeScalars.split {
            !charset.contains($0)
            }.map(String.init)
    }
    
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }

    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            formatter.numberStyle = .currencyAccounting
        } else {
            // Fallback on earlier versions
        }
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    
}


extension UInt {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension NSString {
    
    class func convertFormatOfDate(date: String, originalFormat: String, destinationFormat: String) -> String! {
        
        // Orginal format :
        let dateOriginalFormat = DateFormatter()
        dateOriginalFormat.dateFormat = originalFormat      // in the example it'll take "yy MM dd" (from our call)
        
        // Destination format :
        let dateDestinationFormat = DateFormatter()
        dateDestinationFormat.dateFormat = destinationFormat // in the example it'll take "EEEE dd MMMM yyyy" (from our call)
        
        // Convert current String Date to NSDate
        let dateFromString = dateOriginalFormat.date(from: date)
        
        // Convert new NSDate created above to String with the good format
        let dateFormated = dateDestinationFormat.string(from: dateFromString!)
        
        return dateFormated
        
    }
}
extension CGRect {
    var centerCuadro: CGRect {
        let side = min(width, height)
        
        return CGRect(
            x: midX - side / 2.0,
            y: midY - side / 2.0,
            width: side,
            height: side)
    }
}
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    
}




@discardableResult
func printMessage(message: String) -> String {
    let outputMessage = "Output : \(message)"
    print(outputMessage)
    return outputMessage
}



extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        
        navigationBar.isTranslucent = true
        
        navigationBar.shadowImage = UIImage()
        
        setNavigationBarHidden(false, animated:true)
        
    }
    
    public func hideTransparentNavigationBar() {
        
        setNavigationBarHidden(true, animated:false)
        
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        
    }
    
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    static func imageWithCollor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    class func image(name: String, withColor color: UIColor) -> UIImage? {
        if var image = UIImage(named: name) {
            // begin a new image context, to draw our colored image onto. Passing in zero for scale tells the system to take from the current device's screen scale.
            //  UIGraphicsBeginImageContext(image.size, false, 0)
            UIGraphicsBeginImageContext(image.size)
            
            // get a reference to that context we created
            let context = UIGraphicsGetCurrentContext()
            
            // set the context's fill color
            color.setFill()
            
            // translate/flip the graphics context (for transforming from CoreGraphics coordinates to default UI coordinates. The Y axis is flipped on regular coordinate systems)
            context!.translateBy(x: 0.0, y: image.size.height)
            context!.scaleBy(x: 1.0, y: -1.0)
            
            // set the blend mode to color burn so we can overlay our color to our image.
            context!.setBlendMode(.multiply)
            let rect = CGRect(origin: .zero, size: image.size)
            context?.draw(image.cgImage!, in: rect)
            
            // set a mask that matches the rect of the image, then draw the color burned context path.
            context!.clip(to: rect, mask: image.cgImage!)
            context!.addRect(rect)
            context!.drawPath(using: .fillStroke)
            // generate a new UIImage from the graphics context we've been drawing onto
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return image
        }
        return nil
    }
    
    
}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}

struct Numbers { static let characterSet = CharacterSet(charactersIn: "0123456789") }
extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}



extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(url: url as URL)
            //  request.setValue("<YOUR_HEADER_VALUE>", forHTTPHeaderField: "<YOUR_HEADER_KEY>")
            URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                guard let data = data, error == nil else{
                    NSLog("Image download error: \(String(describing: error))")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode > 400 {
                        let errorMsg = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        NSLog("Image download error, statusCode: \(httpResponse.statusCode), error: \(errorMsg!)")
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    
                }
                
                }.resume()
        }
    }
}
extension UIColor {
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}

extension UIView {
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }
}
extension Data {
    // GET JSONFILE
    static func getJsonFile(fileName: String) -> Any? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    return try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    
                    /*
                     if let dictionary = object as? Any? {
                     return dictionary
                     }*/
                } catch {
                    // print("Error!! Unable to parse  \(fileName).json")
                }
            }
            // print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
    
    // GET JSONFILE
    func loadJson(filename fileName: String) -> [[String: AnyObject]]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dictionary = object as? [[String: AnyObject]] {
                        return dictionary
                    }
                } catch {
                    //  print("Error!! Unable to parse  \(fileName).json")
                }
            }
            //print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
}

extension NSData {
    // Convert from NSData to json object
    func nsdataToJSON(data: NSData) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options:  .mutableContainers)
            
        } catch let myJSONError {
              print(myJSONError)
        }
        return nil
    }
    
    // Convert from JSON to nsdata
    func jsonToNSData(json: AnyObject) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        } catch let myJSONError {
             print(myJSONError)
        }
        return nil;
    }
    
}

extension NSDate
{
    
    /*
     convenience init(dateString:String, format:String="yyyy-MM-dd") {
     let formatter = DateFormatter()
     formatter.timeZone = NSTimeZone.default
     formatter.dateFormat = format
     let d = formatter.date(from: dateString)
     self(timeInterval: 0, since: d!)
     }
     */
    //compare fecha menor a fecha mayor
    static public func <(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b as Date) == ComparisonResult.orderedAscending
    }
    //compare fecha mayor a fecha menor
    
    static public func >(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b as Date) == ComparisonResult.orderedDescending
    }
    //compare si es igual
    
    static public func ==(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b as Date) == ComparisonResult.orderedSame
    }
    
    
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    
}

extension UILabel{
    var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
    
    
}
extension UINavigationItem {
    
    //Make the title 2 lines with a title and a subtitle
    func addTitleAndSubtitleToNavigationBar( title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame:    CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        
        let titleView = UIView(frame:  CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    
}

extension UIViewController {
    
    private var availableWidthForTitle: CGFloat {
        get {
            var total = UIScreen.main.bounds.width
            if let navigationBar = navigationController?.navigationBar {
                var maxYLeft:  CGFloat = 0
                var minYRight: CGFloat = 0
                for subview in navigationBar.subviews.dropFirst()
                    where !subview.isHidden {
                        if subview.frame.origin.x < total / 2 {
                            let rightEdge = subview.frame.origin.x + subview.frame.size.width
                            if rightEdge < total / 2 {
                                maxYLeft = max(maxYLeft, rightEdge)
                            }
                        } else {
                            let leftEdge = subview.frame.origin.x
                            if leftEdge > total / 2 {
                                minYRight = min(minYRight, total - leftEdge)
                            }
                        }
                }
                total = total - maxYLeft - minYRight
            }
            
            return total
        }
    }
    
    func setTitle(title:String, subtitle:String?) {
        if (subtitle == nil) {
            self.title = title.uppercased()
        } else {
            let titleLabel = UILabel(frame: CGRect(x:0 , y: -2, width: 0, height: 0))
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.textColor = UIColor.white
            //            titleLabel.font = Font
            titleLabel.textAlignment = .center
            let availableWidth = availableWidthForTitle
            let titleUppercase = NSString(string: title.uppercased())
            if titleUppercase.boundingRect(
                // if title needs to be truncated
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName : titleLabel.font],
                context: nil).width > availableWidth {
                let truncTitle: NSMutableString = ""
                for nextChar in title.uppercased().characters {
                    if truncTitle.boundingRect(
                        with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                        attributes: [NSFontAttributeName : titleLabel.font],
                        context: nil).width > availableWidth - 16 { // for ellipsis + some margin
                        truncTitle.append("...")
                        break
                    } else {
                        truncTitle.append(String(nextChar))
                    }
                }
                titleLabel.text = truncTitle as String
            } else {
                // use title as-is
                titleLabel.text = titleUppercase as String
            }
            titleLabel.sizeToFit()
            let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
            subtitleLabel.backgroundColor = UIColor.clear
            subtitleLabel.textColor = UIColor.white
            // subtitleLabel.font = MaterialFont.italicSystemFontWithSize(10)
            subtitleLabel.text = subtitle
            subtitleLabel.sizeToFit()
            
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
            // Center title or subtitle on screen (depending on which is larger)
            if titleLabel.frame.width >= subtitleLabel.frame.width {
                var adjustment = subtitleLabel.frame
                adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
                subtitleLabel.frame = adjustment
            } else {
                var adjustment = titleLabel.frame
                adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
                titleLabel.frame = adjustment
            }
            
            titleView.addSubview(titleLabel)
            titleView.addSubview(subtitleLabel)
            self.navigationItem.titleView = titleView
        }
    }
}


public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":
            return "iPod Touch 5"
        case "iPod7,1":
            return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro"
        case "AppleTV5,3":
            return "Apple TV"
        case "i386", "x86_64":
            return "Simulator"
        default:
            return identifier
        }
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
                
            } else {
                
                return vc;
            }
        }
    }
}
