//
//  ContentView.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default) private var pokemons: FetchedResults<Pokemon>
    
    @FetchRequest (
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default)
    private var favorite:FetchedResults<Pokemon>
    
    @State var filterByFavorite = false
    @StateObject private var pokemonVM = PokenmonViewModal(controller: Fetchcontroller())
        
    var body: some View {
        
        switch pokemonVM.status{

        case .sucess:
            NavigationStack {
                List(filterByFavorite ? favorite : pokemons ) { pokemon in
                    NavigationLink(value: pokemon){
                       
                        AsyncImage(url: pokemon.sprites) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        Text("\(pokemon.name!.capitalized)")
                            .font(.headline)
                        if pokemon.favorite{
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemen in
                    PokemonDetail()
                        .environmentObject(pokemen)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            withAnimation {
                                filterByFavorite.toggle()
                            }
                        } label: {
                            Label("Filter By Favorites",systemImage: filterByFavorite ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundColor(.yellow)
                    }
                    
                }
            }
        default:
            ProgressView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
