//
//  ProductViewController.swift
//  Barcode Database App
//
//  Created by Amber King on 2019-07-21.
//  Copyright © 2019 Amber King. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var recyclableImage: UIImageView!
    @IBOutlet weak var biodegradableImage: UIImageView!
    @IBOutlet weak var disposalLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    
    // product info
    var barcode: String = ""
    var product: String = ""
    var company: String = ""
    var image: String = ""
    var recyclable: Bool = false
    var biodegradable: Bool = false
    var disposal: String = ""
    var points: Int = 0
    var suggestions: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
    }
    
    func startLoading() {
        // hide stack view
        stackView.isHidden = true
        
        // start activity indicator
        activityView.isHidden = false
        activityView.startAnimating()
        
        getData()
    }
    
    func getData() {
        let urlPath = "http://eatcofriendly.000webhostapp.com/api/product/read_one.php?barcode=\(barcode)"
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        var json = NSDictionary()
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
        } catch let error as NSError {
            print(error)
        }
        
        // get JSON data
        product = json["product_name"] as? String ?? ""
        company = json["company_name"] as? String ?? ""
        image = json["image"] as? String ?? ""
        recyclable = Int(json["recyclable"] as? String ?? "") == 1
        biodegradable = Int(json["biodegradable"] as? String ?? "") == 1
        disposal = json["disposal"] as? String ?? ""
        points = Int(json["points"] as? String ?? "") ?? 0
        suggestions = json["suggestions"] as? String ?? "No product suggestions."
        
        DispatchQueue.main.async {
            self.stopLoading()
        }
    }
    
    func stopLoading() {
        // stop activity indicator
        activityView.isHidden = true
        activityView.stopAnimating()
        
        if product == "" {
            // display error message if barcode is not found in database
            let alertController = UIAlertController(title: "Product Not Found", message: "Product with barcode \(barcode) not found in database.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.performSegue(withIdentifier: "back", sender: self)  // go back to scan
            })
            present(alertController, animated: true)
        } else {
            // show stack view
            stackView.isHidden = false
            
            // set labels
            productLabel.text = product
            companyLabel.text = company
            pointsLabel.text = String(points)
            disposalLabel.text = disposal
            suggestionsLabel.text = suggestions
            
            print(disposal)
            
            // load image from url
            let url = URL(string: image)!
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                productImage.image = UIImage(data: imageData)
            }
            
            // set recycling image
            if (recyclable) {
                recyclableImage.image = UIImage(named: "recyclable")
            }
            
            // set biodegradable image
            if (biodegradable) {
                biodegradableImage.image = UIImage(named: "biodegradable")
            }
        }
        
    }
    
}
