//
//  ViewController.swift
//  WeatherApp
//
//  Created by NOWALL on 2016/11/12.
//  Copyright © 2016年 NOWALL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var dateLabelCollection: [UILabel]!
    @IBOutlet var weatherImageCollection: [UIImageView]!
    @IBOutlet var weatherLabelCollection: [UILabel]!
    @IBOutlet var temperatureLabelCollection: [UILabel]!
    
    let weatherApiUrl: String = "http://weather.livedoor.com/forecast/webservice/json/v1?city=030010"

    // called when view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // publish http request
        Alamofire.request(weatherApiUrl).responseJSON {
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
            
            // タイトル部分(都市名)の表示
            self.titleLabel.text = json["title"].stringValue
            
            // 天気の情報
            if let forecasts = json["forecasts"].array {
                
                // 要素数分だけ、loop
                for i in 0 ..< forecasts.count {
                    // 日付を表示
                    self.dateLabelCollection[i].text = forecasts[i]["dateLabel"].stringValue
                    // 天候を表示
                    self.weatherLabelCollection[i].text = forecasts[i]["telop"].stringValue
                    // 温度を表示
                    self.temperatureLabelCollection[i].text = self.generateTemperatureText(forecasts[i]["temperature"])
                    self.weatherImageCollection[i].sd_setImage(with: URL(string: forecasts[i]["image"]["url"].stringValue))
                }
            }
        }
    }
    
    // 気温のラベル用テキストを生成します。
    func generateTemperatureText(_ temperature: JSON) -> String {
        
        var resultText = ""
        
        if let min = temperature["min"]["celsius"].string {
            resultText += min + "℃"
        } else {
            resultText += "-"
        }
        
        resultText += " / "
        
        if let max = temperature["max"]["celsius"].string {
            resultText += max + "℃"
        } else {
            resultText += "-"
        }
        
        return resultText
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
}








