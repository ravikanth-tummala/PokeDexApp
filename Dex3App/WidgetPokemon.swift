//
//  WidgetPokemon.swift
//  Dex3App
//
//  Created by GeoSpark on 21/11/22.
//

import SwiftUI

enum WidgetSize {
    case small, medium, large
}
struct WidgetPokemon: View {
    @EnvironmentObject var pokemon:Pokemon
    let widgetSize :WidgetSize
    
    var body: some View {
        ZStack{
            Color(pokemon.types![0].capitalized)
            
            switch widgetSize {
            case .small:
                FetchImage(url: pokemon.sprites)
            case .medium:
                HStack{
                    FetchImage(url: pokemon.sprites)
                    
                    VStack(alignment: .leading){
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing,30)
                }
            case .large:

                FetchImage(url: pokemon.sprites)
                
                VStack{
                    HStack{
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title)
                    }
                }
                .padding()
            }
        }
    }
}

struct WidgetPokemon_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPokemon(widgetSize: .large)
            .environmentObject(SamplePokemon.samplePokemon!)
    }
}
