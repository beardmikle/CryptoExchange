//
//  ViewController.swift
//  СryptoValues
//
//  Created by beardmikle on 15.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btcPrice: UILabel!
    @IBOutlet weak var ethPrice: UILabel!
    @IBOutlet weak var usdPrice: UILabel!
    @IBOutlet weak var audPrice: UILabel!
    @IBOutlet weak var lastUpdatePrice: UILabel!
    @IBOutlet weak var timeCurrent: UILabel!

    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        showDate()
        
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        
    }
    
    func showDate()
    {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd.MM.yyyy"
        
        let dateShow = dateForm.string(from: Date())
        timeCurrent.text = "Current date: " + dateShow
    }

    @objc func refreshData() -> Void
    {
        fetchData()
    }
    
    
    func fetchData()
    {
        let url = URL(string: urlString)
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in
        
            if(error != nil)
            {
                print(error)
                return
            }
            
            do
            {
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency: json.rates)
            }
            catch
            {
                print(error)
                return
            }
        }
        dataTask.resume()
    }
    
    func setPrices(currency: Currency)
    {
        DispatchQueue.main.async
        {
            self.btcPrice.text = self.formatPrice(currency.btc)
            self.ethPrice.text = self.formatPrice(currency.eth)
            self.usdPrice.text = self.formatPrice(currency.usd)
            self.audPrice.text = self.formatPrice(currency.aud)
            self.lastUpdatePrice.text = self.formatDate(date: Date())
        }
    }
    
    func formatPrice(_ price: Price) -> String
    {
        return String(format: "%@ %.4f", price.unit, price.value)
    }
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y (HH:mm:ss)"
        return formatter.string(from: date)
    }
    
    
    struct Rates: Codable
    {
        let rates: Currency
    }
    
    struct Currency: Codable
    {
        let btc: Price
        let eth: Price
        let usd: Price
        let aud: Price
    }
    
    struct Price: Codable
    {
        let name: String
        let unit: String
        let value: Float
        let type: String
        
    }
}


