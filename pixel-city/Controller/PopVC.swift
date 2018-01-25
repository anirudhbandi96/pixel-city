//
//  PopVC.swift
//  pixel-city
//
//  Created by Caleb Stultz on 7/20/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit


class PopVC: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    
    

    @IBOutlet weak var photoInfoView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var popImageView: UIImageView!
    @IBOutlet weak var infoBtn: UIButton!
    var passedImage: UIImage!
   
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet weak var photoTakenLocation: MKMapView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView(){
        
        popImageView.image = passedImage
        popImageView.contentMode = .scaleAspectFill
        addDoubleTap()
        
        photoInfoView.isHidden = true
        photoInfoView.layer.cornerRadius = 15.0
        photoInfoView.clipsToBounds = true
        photoInfoView.layer.borderWidth = 1
        photoInfoView.layer.borderColor = UIColor.black.cgColor
        
        infoView.layer.cornerRadius = 5.0
        infoView.clipsToBounds = true
        
       
        
        
        
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    func setupImageInfo(forImageid id:String , withSecretKey key: String){
        let infoUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&photo_id=\(id)&secret=\(key)&format=json&nojsoncallback=1"
        
        Alamofire.request(infoUrl).responseJSON(completionHandler: { (data) in
            
            let string = "_content"
            guard let json = data.result.value as? Dictionary<String,Any> else { return }
            let photo = json["photo"] as! Dictionary<String,Any>
            let owner = photo["owner"] as! Dictionary<String,Any>
            let username = owner["username"] as! String
            //let realname = owner["realname"] as! String
            let title = photo["title"] as! Dictionary<String,String>
            let titleContent = title[string]
            let comments = photo["comments"] as! Dictionary<String,String>
            let commentsContent = comments[string]
            //let desc = photo["description"] as! Dictionary<String,String>
            //let description = desc[string] as! String
            let dates = photo["dates"] as! Dictionary<String,Any>
            let dateUploaded = dates["taken"] as! String
            let views = photo["views"] as! String
            let loc =  photo["location"] as! Dictionary<String,Any>
            let latitude = loc["latitude"] as! String
            let longitude = loc["longitude"] as! String
            let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
           
            self.usernameLabel.text = username
            self.uploadDateLabel.text = dateUploaded
            self.photoTitle.text = titleContent
            self.viewsLabel.text = "\(views) views"
            self.commentsLabel.text = commentsContent! + " comments"
            
            let pin = Pin(coordinate: location.coordinate)
            self.photoTakenLocation.addAnnotation(pin)
            
            let regionRadius : Double = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            self.photoTakenLocation.setRegion(coordinateRegion, animated: true)
            
    })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func infoBtnPressed(_ sender: Any) {
       photoInfoView.isHidden  = !photoInfoView.isHidden
    }
}
