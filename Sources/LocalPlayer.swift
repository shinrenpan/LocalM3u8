//
//  Copyright (c) 2023 shinren.pan@gmail.com All rights reserved.
//

import AVFoundation

final class LocalPlayer: AVPlayer {
    
    init(m3u8Path: String) {
        super.init()
        
        if let url = URL(string: m3u8Path) {
            let asset = AVURLAsset(url: url)
            asset.resourceLoader.setDelegate(self, queue: .main)
            let item = AVPlayerItem(asset: asset)
            replaceCurrentItem(with: item)
        }
        else {
            replaceCurrentItem(with: nil)
        }
    }
}

// MARK: - AVAssetResourceLoaderDelegate

extension LocalPlayer: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        handleLoadingRequest(renewalRequest)
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        handleLoadingRequest(loadingRequest)
    }
}

// MARK: - Handle Something

private extension LocalPlayer {
    func handleLoadingRequest(_ request: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = request.request.url else {
            return false
        }
        
        if url.absoluteString.isEmpty {
            return false
        }
        
        // 這裡要用 fileURLWithPath
        // 或是使用 NSData
        // NSData(contentsOfFile: url.absoluteString)
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: url.absoluteString)) else {
            return false
        }
        
        if data.isEmpty {
            return false
        }
        
        request.dataRequest?.respond(with: data)
        request.finishLoading()
        
        return true
    }
}
