//
//  Model.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 19/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class Currency {
    var NumCode: String?
    var CharCode: String?
    var Nominal: String?
    var nominalDouble: Double?
    var Name: String?
    var Value: String?
    var valueDouble: Double?
    
    var imageFlag: UIImage? {
        if let CharCode = CharCode {
            return UIImage(named: CharCode)
        }
        return nil
    }
    
    class func rouble() -> Currency {
        let r = Currency()

        r.CharCode = "RUR"
        r.Nominal = "1"
        r.nominalDouble = 1
        r.Name = "Российский рубль"
        r.Value = "1"
        r.valueDouble = 1
        
        return r
    }
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (fromCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        
        return String(d)
        
    }
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
//        print(path)
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
//    загрузка файла с cbr.ru исохранение его в каталоге приложения
//    http://www.cbr.ru/scripts/XML_daily.asp?date_req=19/05/2019
    func loadXMLFile (date: Date?) {

        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl + dateFormatter.string(from: date!)
            print(strUrl)
        }
    
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var errorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: urlForSave)
//                    print(path)
//                    print("Файл загружен!")
                    self.parseXML()
                } catch {
                    print(error.localizedDescription)
                    errorGlobal = error.localizedDescription
                }
                
            } else {
                print(error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("errorWhenXMLLoading"), object: self, userInfo: ["ErrorName" : errorGlobal])
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        
        task.resume()
    }
    
//    распарсить файл XML и положить его  в currencies: [Currency}], отправить уведомление приложение? о том? что данные обновились
    func parseXML() {
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
//        print("Данные обновлены!")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        
        for c in currencies {
            if c.CharCode == fromCurrency.CharCode {
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode {
                toCurrency = c
            }
        }
    }
    
    var currentCurrency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
        
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "NumCode" {
            currentCurrency?.NumCode = currentCharacters
        }
        
        if elementName == "CharCode" {
            currentCurrency?.CharCode = currentCharacters
        }
        
        if elementName == "Nominal" {
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Name" {
            currentCurrency?.Name = currentCharacters
        }
        
        if elementName == "Value" {
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
        
    }
    
}
