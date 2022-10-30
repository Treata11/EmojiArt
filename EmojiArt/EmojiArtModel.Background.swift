//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import Foundation

extension EmojiArtModel {
    enum Background: Equatable, Codable {
        case blank
        case url(URL) // When associated values are available in an enum, enum must be manually be conformed to Codable
        case imageData(Data) //
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let url = try? container.decode(URL.self, forKey: .url) {
                self = Background.url(url)
            } else if let imageData = try? container.decode(Data.self, forKey: .imageData) {
                self = .imageData(imageData)
            } else {
                self = .blank
            }
        }
        enum CodingKeys: String, CodingKey {
            case url = "TheURL"
            case imageData
        }
        
        func encode(to encoder: Encoder) throws { // Implement on first hand - then create the initializer to decode the encoded JSON
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .url(let url): try container.encode(url, forKey: CodingKeys.url)
            case .imageData(let data): try container.encode(data, forKey: CodingKeys.imageData)
            case .blank: break
            }
        }
        
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
