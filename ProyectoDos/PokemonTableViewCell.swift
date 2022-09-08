//
//  PokemonTableViewCell.swift
//  ProyectoDos
//
//  Created by Universidad Anahuac on 05/09/22.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView(pokemon: Pokemon){
        loadingView.hidesWhenStopped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.loadPokemon(pokemon: pokemon)
        }
        self.texto.text = pokemon.name
        loadPokemon(pokemon: pokemon)
    }
    
    func loadPokemon(pokemon: Pokemon){
        self.loadingView.startAnimating()
        self.imagen.isHidden = true
            let task = URLSession.shared.dataTask(with: URL(string: pokemon.url)!) { data, response, error in
                let pokemonDetail = try! JSONDecoder().decode(PokemonDetail.self, from: data!)
                print(pokemonDetail)
                self.loadPokemonImage(urlImage: pokemonDetail.sprites.other.home.front_default)
            }
            task.resume()
    }
    
    func loadPokemonImage(urlImage: String) {
        let task = URLSession.shared.dataTask(with: URL(string: urlImage)!) {data, response, error in
            if let data = data {
                let image = UIImage.init(data: data)
                DispatchQueue.main.sync {
                    self.loadingView.stopAnimating()
                    self.imagen.image = image
                    self.imagen.isHidden = false
                }
            }
        }
        task.resume()
    }
}
