//
//  PokenmonViewModal.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import Foundation

@MainActor
class PokenmonViewModal: ObservableObject {
    
    enum Status{
        case notStarted
        case fecthing
        case sucess
        case failed(error:Error)
    }
    
    @Published private(set) var status = Status.notStarted
    private let controller:Fetchcontroller
    
    init(controller: Fetchcontroller) {
        self.controller = controller
        
        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async{
        status = .fecthing
        do {
            guard var pokedex = try await controller.fetchAllPokenmon() else {
                print("Pokemon Already been got")
                status = .sucess
                return
            }
            
            pokedex.sort{$0.id < $1.id }
            
            for pokemen in pokedex{
                let newPokenmon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokenmon.id = Int16(pokemen.id)
                newPokenmon.name = pokemen.name
                newPokenmon.types = pokemen.types
                newPokenmon.organizeType()
                newPokenmon.hp = Int16(pokemen.hp)
                newPokenmon.attack = Int16(pokemen.attack)
                newPokenmon.speed = Int16(pokemen.speed)
                newPokenmon.specialAttack = Int16(pokemen.specialAttack)
                newPokenmon.specialDefence = Int16(pokemen.specialDefense)
                newPokenmon.defence = Int16(pokemen.defense)
                newPokenmon.sprites = pokemen.sprite
                newPokenmon.shiny = pokemen.shiny
                newPokenmon.favorite = false

                try PersistenceController.shared.container.viewContext.save()
            }
            status = .sucess
        }catch {
            status = .failed(error: error)
        }
    }
}
