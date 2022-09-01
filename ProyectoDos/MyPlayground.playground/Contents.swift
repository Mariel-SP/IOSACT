import UIKit
import Foundation

struct PokemonList: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Pokemon]
}

struct Pokemon: Decodable {
    var name: String
    var url: String
}

let urlBase = "https://pokeapi.co/api/v2/"

let listPokemonEndPoint = URL.init(string: "\(urlBase)pokemon?limit=100000&offset=0")!
let task = URLSession.shared.dataTask(with: listPokemonEndPoint){data, response, error in
    if let data = data {
        let jsonDecoder = JSONDecoder()
        let result = try! jsonDecoder.decode(PokemonList.self, from: data)
        
        print(result)
        
    }
}
task.resume()
