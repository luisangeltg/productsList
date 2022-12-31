//
//  DisplayTableViewModel.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 26/12/22.
//

import Foundation

class ItemViewModel {
    
    public var selected : Product?
    
    public static let shared = ItemViewModel()
    private var item = Item(products: [], total: 0, skip: 0, limit: 0)
    
    private init() {
        fetch { [weak self] done in
            if done {
                print("datos actualizados: ", self?.item.limit ?? "empty item")
            } else {
                print("error datos no actualizados")
            }
        }
    }
    
    func products() -> [Product]{
        return item.products
    }
    
    func fetch(completion: @escaping(_ done : Bool) -> Void ){
        guard let url = URL(string: "http://dummyjson.com/products") else { return }
        
        URLSession.shared.dataTask(with: url){ [weak self] data, _, _ in
            guard let data = data else { return }
            do{
                let jsonData = try JSONDecoder().decode(Item.self, from: data)
                DispatchQueue.main.async {
                    self?.item = jsonData
                    completion(true)
                }
            }catch let error as NSError {
                print("Error en la petición: ", error.localizedDescription)
            }
        }.resume()
    }
    
    func sortProductsByTitle() {
        let products = products().sorted(by: { $0.title < $1.title })
        let newItem = Item(products: products, total: item.total, skip: item.skip, limit: item.limit)
        item = newItem
    }
    
    func sortProductsByID(){
        let products = products().sorted(by: { $0.id < $1.id })
        let newItem = Item(products: products, total: item.total, skip: item.skip, limit: item.limit)
        item = newItem
    }
    
    func putOnTop(newTopID: Int) {
        let newTop = products()[newTopID]
        var newProductsArray = [Product]()
        newProductsArray.append(newTop)
        for i in 0...item.products.count-1 {
            if newTop.id != item.products[i].id {
                newProductsArray.append(item.products[i])
            }
        }
        //Se reemplaza el orden del arreglo
        item.products = newProductsArray
    }
    
    static func priceToCurrency(price: Int) -> String{
        let intValue = price

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        if let formattedValue = formatter.string(from: NSNumber(value: intValue)) {
            return formattedValue// prints "$12,345.00"
        }
        return "Error"
    }
    
    func getUrls() -> [URL] {
        guard let images = selected?.images else { return [] }
        return images.compactMap { URL(string: $0) }
    }

}
