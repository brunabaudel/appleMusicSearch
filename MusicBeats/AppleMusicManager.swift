//
//  MusicManager.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 19/10/23.
//

import Foundation
import MusicKit

final class AppleMusicManager: ObservableObject {
    @Published var musicSubscription: MusicSubscription?
    @Published var previewAssetsCatalogSearch = [PreviewAsset]()
    @Published var loading = false
    
    private let itemsFromEndThreshold = 25
    private var itemsLoadedCount: Int?
    private var offset = 0
    
    public func requestMoreItemsIfNeeded(index: Int, text: String) {
        guard let itemsLoadedCount = itemsLoadedCount else {
            return
        }
        
        if thresholdMeet(itemsLoadedCount, index) {
            offset += 1
            requestItems(offset: offset, text: text)
        }
    }
    
    public func requestItems(offset: Int, text: String) {
        loading = true
        Task {
            var request = MusicCatalogSearchRequest(term: text, types: [Song.self])
            request.limit = 25
            request.offset = offset
            let response = await self.fetchMusic(request)
            await MainActor.run {
                previewAssetsCatalogSearch.append(contentsOf: response)
                itemsLoadedCount = previewAssetsCatalogSearch.count
                loading = false
            }
        }
    }
    
    public func didMusicSubscription() async {
        for await subscription in MusicSubscription.subscriptionUpdates {
            musicSubscription = subscription
        }
    }
    
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return (itemsLoadedCount - index) == itemsFromEndThreshold
    }
    
    private func fetchMusic(_ request: MusicCatalogSearchRequest) async -> [PreviewAsset] {
        if await didMusicAuthorization() {
            do {
                let result = try await request.response()
                return result.songs.compactMap({
                    return .init(name: $0.title,
                                 artist: $0.artistName,
                                 imageURL: $0.artwork?.url(width: 75, height: 75),
                                 previewSongURL: $0.previewAssets?.first?.url)
                })
            } catch {
                print(String(describing: error))
            }
        }
        return []
    }
    
    private func didMusicAuthorization() async -> Bool {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }
}
