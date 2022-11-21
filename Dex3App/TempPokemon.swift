//
//  TempPokemon.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import Foundation

struct TempPokemon: Codable{
    let id: Int
    let name: String
    let types:[String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    let sprite:URL
    let shiny:URL
    
    enum PokemonKeys:String, CodingKey{
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionarykeys:String, CodingKey{
            case type
            enum TypeKeys: String, CodingKey{
                case name
            }
        }
        
        enum StatDictionarykeys:String, CodingKey{
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey{
                case name
            }
        }
        
        enum SpriteDictionarykeys:String, CodingKey{
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes:[String] = []
        var typeContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typeContainer.isAtEnd{
            let typeDictContainer = try typeContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionarykeys.self)
            let typeContainer = try typeDictContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionarykeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd{
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionarykeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionarykeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self,forKey:.name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey:.value)
            default:
                print("It will never get here so.....")
            }
        }
    
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteDictionarykeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
 
    }
}
