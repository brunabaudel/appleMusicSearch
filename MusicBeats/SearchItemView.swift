//
//  SearchItemView.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 24/10/23.
//

import SwiftUI

struct SearchItemView: View {
    @StateObject var playerManager: PlayerManager
    let previewAsset: PreviewAsset
    
    var body: some View {
        HStack {
            AsyncImage(url: previewAsset.imageURL)
                .frame(width: 75, height: 75, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(previewAsset.name)
                    .font(.title3)
                Text(previewAsset.artist)
                    .font(.footnote)
            }
            
            Spacer()
            
            SongButton(playerManager: playerManager, previewAsset: previewAsset)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchItemView(playerManager: PlayerManager(), previewAsset: PreviewAsset(name: "", artist: "", imageURL: nil, previewSongURL: nil))
    }
}
