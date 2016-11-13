//
//  wholeViewController.swift
//  WeatherApp
//
//  Created by NOWALL on 2016/11/13.
//  Copyright © 2016年 NOWALL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class wholeViewController: UIViewController {
    
    @IBOutlet var citiesLabelCollection: [UILabel]!
    
    let citiesArray: [String] = [
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=012010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=390010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=230010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=270000",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=400010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=030010",
        "http://weather.livedoor.com/forecast/webservice/json/v1?city=471010",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< citiesArray.count {
            addWeather(url: citiesArray[i], index: i)
        }
    }
    
    func addWeather(url: String, index: Int) {
         print(url)
        
        // publish http request
        Alamofire.request(url).responseJSON {
            (response: DataResponse<Any>) in
            
            // error handling: 通信エラーの確認
            if response.result.isFailure == true {
                // show alert
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            
            // error handling: 通信結果のチェック
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
            }
            
            // responseJSONを使うと辞書形式でも扱えますが、今回はより簡単に扱うためにSwiftyJSONを利用します。
            let json = JSON(val)
            print(json)
            
            // タイトル部分(都市名)の表示
           
            let pref:String = json["location"]["prefecture"].stringValue + " " + json["location"]["city"].stringValue
             self.citiesLabelCollection[index].text = pref + " : " + json["forecasts"][0]["telop"].stringValue
        }
    }
    
    // 閉じるボタンのみのアラートを表示させるための関数
    func simpleAlert(title: String, message: String) {
        // alertオブジェクトを生成
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // 閉じるactionを追加
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        // alertをshow
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
