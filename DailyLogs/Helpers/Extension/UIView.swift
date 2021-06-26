//
//  UIView.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit
import MapKit
import CoreLocation

extension UIView {
    
    func setCorner(withRadius radii: CGFloat = 5.0) {
        layer.cornerRadius = radii
        layer.masksToBounds = true
    }
    
    func setShadow(color: UIColor = .darkGray, sRadius: CGFloat = 4.0) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius  = sRadius
        self.layer.shadowColor   = color.cgColor
        self.layer.shadowOffset  = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.contentsScale = UIScreen.main.scale
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func openAppleMap(jobName: String = "Target location", latitude: Double, longitude: Double ) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = jobName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func addRoundedBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "masklayer"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        border.cornerRadius = width*0.5
        clipsToBounds = true
        self.layer.addSublayer(border)
    }
    
    func setBorder(withColor color: UIColor = .clear, borderWidth width: CGFloat = 0, cornerRadius radius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
//    func openGoogleMap(_ lat: Double,_ long: Double ) {
//        fatalError("Please add below line before using this method.")
//        /**
//         <key>LSApplicationQueriesSchemes</key>
//         <array>
//         <string>comgooglemaps</string>
//         <string>comgooglemaps-x-callback</string>
//         </array>
//         */
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
//                UIApplication.shared.open(url, options: [:])
//            }
//        } else {
//            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
//                UIApplication.shared.open(urlDestination)
//            }
//        }
//    }
    
}
