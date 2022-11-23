//
//  Persistence.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let samplePokemon = Pokemon(context: viewContext)
        samplePokemon.id = 1
        samplePokemon.name = "bulbasaur"
        samplePokemon.types = ["grass","poison"]
        samplePokemon.hp = 45
        samplePokemon.attack = 49
        samplePokemon.defence = 49
        samplePokemon.specialAttack = 65
        samplePokemon.specialDefence = 65
        samplePokemon.speed = 50
        samplePokemon.sprites = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png")
        samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        samplePokemon.favorite = false

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()


    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex3App")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }else{
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.roam.Dex3App")!.appending(path: "Dex3App.sqlite")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
