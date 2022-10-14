//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import Foundation

extension EmojiArtModel {
    
    enum Background: Equatable {
        case blank
        case url(URL)
        case imageData(Data)
        
        var url: URL? {     //syntactic sugar
            switch self {
            case .url(let url): return url
            default : return nil
            }
        }
        var imageData: Data? {      //syntactic sugar
            switch self {
            case .imageData(let imageData): return imageData
            default: return nil
            }
        }
        
    }
    
}
