//
//  RemoteImageView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 16/04/2026.
//

import SwiftUI

struct RemoteImageView: View {
    let urlString: String?
    
    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
}

