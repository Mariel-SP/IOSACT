//
//  File.swift
//  ProyectoDos
//
//  Created by Universidad Anahuac on 05/09/22.
//

import Foundation

struct PokemonDetail : Decodable{
    var sprites: pokemonDetailSprite
}

struct pokemonDetailHome : Decodable{
    var front_default: String
}

struct pokemonDetailOther : Decodable{
    var home: pokemonDetailHome
}

struct pokemonDetailSprite: Decodable {
    var other: pokemonDetailOther
}
