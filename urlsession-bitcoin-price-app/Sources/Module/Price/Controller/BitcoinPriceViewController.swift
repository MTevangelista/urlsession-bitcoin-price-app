import UIKit

public final class BitcoinPriceViewController: UIViewController {
    
    private var currentBitcoinPrice: String = ""
    private let bitcoinPriceView: BitcoinPriceView
    
    public init() {
        bitcoinPriceView = BitcoinPriceView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        fetchCurrentBitcoinPrice { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let price = response else { return  }
            self.bitcoinPriceView.build(.init(price: price))
        }
        
        view = bitcoinPriceView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.bitcoinPriceView.delegate = self
    }
    
}

extension BitcoinPriceViewController: BitcoinPriceViewDelegate {
    
    public func didSelectUpdateButton() {
        fetchCurrentBitcoinPrice { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let price = response else { return  }
            self.bitcoinPriceView.build(.init(price: price))
        }
    }
    
}

extension BitcoinPriceViewController {
    
    private func formatPrice(_ price: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "pt_BR")
        guard let formattedPrice = numberFormatter.string(from: price) else { return "0,00" }
        return formattedPrice
    }
    
    private func fetchCurrentBitcoinPrice(completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://www.mercadobitcoin.net/api/BTC/ticker") else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error when making the price query: \(String(describing: error.localizedDescription))")
                completion(nil, error)
            }
            guard let responseData = data else { return completion(nil, error) }
            do {
                guard
                    let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : AnyObject],
                    let ticker = jsonObject["ticker"],
                    let last = ticker["last"] as? String
                else { return completion(nil, error) }
                guard let last = Double(last) else { return completion(nil, error) }
                let formattedPrice = self.formatPrice(NSNumber(value: last))
                completion(formattedPrice, nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
}
