//
//  SearchView.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 17/10/23.
//

import SwiftUI
import MusicKit

struct SearchView: View {
    @StateObject var playerManager = PlayerManager()
    @StateObject var appleMusicManager = AppleMusicManager()
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if !appleMusicManager.previewAssetsCatalogSearch.isEmpty {
                    List(Array(appleMusicManager.previewAssetsCatalogSearch.enumerated()), id: \.element) { index, previewAsset in
                        SearchItemView(playerManager: playerManager, previewAsset: previewAsset)
                        .onAppear { appleMusicManager.requestMoreItemsIfNeeded(index: index, text: searchText) }
                    }
                    
                    if appleMusicManager.loading { ProgressView() }
                    
                } else if appleMusicManager.loading {
                    ProgressView()
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            appleMusicManager.previewAssetsCatalogSearch.removeAll()
            appleMusicManager.requestItems(offset:0, text:searchText.lowercased())
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
