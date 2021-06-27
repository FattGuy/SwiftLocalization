//
//  LanguageService.swift
//  SwiftLocalization
//
//  Created by Feng Chang on 6/27/21.
//

import Foundation
import UIKit

class LanguageService {
    static var shared = LanguageService()
    var labelView:UIVisualEffectView = UIVisualEffectView()
    var labelVerifying:UILabel = UILabel()
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    func getLanguagesFromServer(url: URL,fromVC:UIViewController)  {
//        self.showLoading()
        let task = URLSession.shared.dataTask(with: url as URL) { data, response, error in
//            self.dismissLoading()
            guard let dataResponse = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                                                        dataResponse, options: []) as?  [String : Any]
                if let languagesArray = jsonResponse!["languages"] as? [[String : Any]] {
                    for lang in languagesArray {
                        let translations = lang["translations"] as? Dictionary<String,String>
                        let langName = lang["code"] as? String
                        let dict : Dictionary<String, Dictionary<String, String>> = [langName!: translations!]
                        let rt = Localization(translations:dict)
                        do {
                            _ = try rt.writeToBundle()
                        }catch {
                            print("error")
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
        
    }
}
