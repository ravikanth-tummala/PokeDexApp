//
//  FetchImage.swift
//  Dex3App
//
//  Created by GeoSpark on 21/11/22.
//

import SwiftUI

struct FetchImage: View {
    let url: URL?
    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        }else{
            Image("bulbasaur")
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)

        }
    }
}

struct FetchImage_Previews: PreviewProvider {
    static var previews: some View {
        FetchImage(url: SamplePokemon.samplePokemon?.sprites)
    }
}
