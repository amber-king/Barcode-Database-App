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
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var disposalLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    
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
        
        getData()
    }
    
    func getData() {
        let urlPath = "http://eatcofriendly.000webhostapp.com/api/product/read_one.php?barcode=" + barcode
        
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
        
        product = json["product_name"] as? String ?? ""
        company = json["company_name"] as? String ?? ""
        image = json["image"] as? String ?? ""
        recyclable = json["recyclable"] as? Bool ?? false
        biodegradable = json["biodegradable"] as? Bool ?? false
        disposal = json["disposal"] as? String ?? ""
        points = json["points"] as? Int ?? 0
        suggestions = json["suggestions"] as? String ?? ""
        
        DispatchQueue.main.async {
            self.setLabels()
        }
    }
    
    func setLabels() {
        
        productLabel.text = product
        companyLabel.text = company
        pointsLabel.text = String(points)
        disposalLabel.text = disposal
        suggestionsLabel.text = suggestions
        
        productImage.image = UIImage(named: image)
        
        /*
        if (recyclable) {
            recyclableImage.image = UIImage(named: "recyclable")
        }
        
        if (biodegradable) {
            biodegradableImage.image = UIImage(named: "biodegradable")
        }
 */
    }
    
}
