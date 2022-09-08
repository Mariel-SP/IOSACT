//
//  DetailedPokemonViewController.swift
//  ProyectoDos
//
//  Created by Universidad Anahuac on 31/08/22.
//

import UIKit

class DetailedPokemonViewController: UIViewController {
    
    var pokemons: Pokemon? = nil

    @IBOutlet weak var nombrePokemon: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nombrePokemon.text = pokemons?.name
        loadPokemon()
    }
    
    func loadPokemon(){
        if let pokemon = pokemons {
            let task = URLSession.shared.dataTask(with: URL(string: pokemon.url)!) { data, response, error in
                let pokemonDetail = try! JSONDecoder().decode(PokemonDetail.self, from: data!)
                print(pokemonDetail)
                self.loadPokemonImage(urlImage: pokemonDetail.sprites.other.home.front_default)
            }
            task.resume()
        }
    }
    
    func loadPokemonImage(urlImage: String) {
        let task = URLSession.shared.dataTask(with: URL(string: urlImage)!) {data, response, error in
            if let data = data {
                let image = UIImage.init(data: data)
                DispatchQueue.main.sync {
                    self.pokemonImageView.image = image
                }
            }
        }
        task.resume()
    }

}
