//
//  Fetchcontroller.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import Foundation
import CoreData

struct Fetchcontroller{
    enum Network:Error {
        case badURL,badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokenmon() async throws -> [TempPokemon]?{
        if havePokemen(){
            return nil
        }
        var allPokemon:[TempPokemon] = []
        
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        guard let fetchURL = fetchComponents?.url else {
            throw Network.badURL
        }
        
        let (data,response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw Network.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any] ,
              let pokDex = pokeDictionary["results"] as? [[String:Any]]
        else {
            throw Network.badResponse
        }
        
        for pokemon in pokDex {
            if let url = pokemon["url"] as? String{
                allPokemon.append(try await fetchPoken(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPoken(from url:URL) async throws -> TempPokemon{
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw Network.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        print("Fetch \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
    
    private func havePokemen() -> Bool{
        let context = PersistenceController.shared.container.newBackgroundContext()
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1,386])
        do {
            let checkPokemon =  try context.fetch(fetchRequest)
            
            if checkPokemon.count == 2 {
                return true
            }
        }catch{
            print("Fetch failes \(error)")
            return false
        }
        return false
    }
}
