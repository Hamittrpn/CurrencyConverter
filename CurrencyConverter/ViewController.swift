//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Hamit  Tırpan on 5.10.2019.
//  Copyright © 2019 Hamit  Tırpan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func getRatesClicked(_ sender: Any) {
        /*
         Api işlemlerini 3 adımda gerçekleştireceğiz;
         1) Request & Session
         2) Get Response & Data
         3) Parsing & JSON Serialization
        */
        
        // 1.
        // Normalde http bağlantılarına izin verilmediği için info.plist'ten ayarları yapmalıyım.(App Transform Security Settings) Bu seçeneği ekledikten sonra yandaki ok tuşunu aşağı yönde çevirip tekrar + yapıp Allow Arbitrary Loads --> YES yaparsam artık http için izin verilir.
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=YOUR API_KEY")
        
        // Projemin her yerinden erişilebilecek
        let session = URLSession.shared
        
        //Closure
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                // 2.
                if data != nil{
                    do{
                    // Json veriyi Dictionary'e cast ettim ki istediğim veriyi seçip alabileyim.
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        //ASYNC (Labellarım UI katmanında sürekli güncelleneceği için bunu main thread'te yapmalıyım.)
                        
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double{
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double{
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let turkish = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY: \(turkish)"
                                }
                            }
                        }
                    }catch{
                        print("Error")
                    }
                }
            }
        }
        // Yukarıdaki tüm işlemlerin aslında devam edebilmesi için bunu kullanmak zorundayım !
        task.resume()
    }
}

