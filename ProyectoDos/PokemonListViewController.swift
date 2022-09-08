//
//  PokemonListViewController.swift
//  ProyectoDos
//
//  Created by Universidad Anahuac on 29/08/22.
//

import UIKit

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

class GoToPokemon{
    var title: String
    var segueId: String
    
    init(title: String, segueId: String){
        self.title = title
        self.segueId = segueId
    }
}

class PokemonListViewController: UIViewController {

    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var pokemonTableView: UITableView!
    
    var pokemons: [Pokemon] = []
    var currentPokemon: Pokemon? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        pokemonTableView.dataSource = self
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.loadPokemons()
        }
        pokemonTableView.delegate = self

    }
    
    func loadPokemons(){
        let urlBase = "https://pokeapi.co/api/v2/"
        let listPokemonEndPoint = URL.init(string: "\(urlBase)pokemon?limit=100000&offset=0")!
        let task = URLSession.shared.dataTask(with: listPokemonEndPoint){data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let result = try! jsonDecoder.decode(PokemonList.self, from: data)
                self.pokemons = result.results
                DispatchQueue.main.sync {
                    self.loadingIndicatorView.stopAnimating()
                    self.pokemonTableView.reloadData()
                }
                
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "especificPokemonSegue" {
            let detailedPokemonViewController = segue.destination as? DetailedPokemonViewController
            detailedPokemonViewController?.pokemons = currentPokemon
        }
    }

}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = pokemonTableView.dequeueReusableCell(withIdentifier: "pokemonCell") as? PokemonTableViewCell
        if(cell == nil){
            cell = PokemonTableViewCell()
        }
        let item = pokemons[indexPath.row]
        //cell?.textLabel?.text = item.name
        cell?.setupView(pokemon: item)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "especificPokemonSegue", sender: nil)
    }

}

