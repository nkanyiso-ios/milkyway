import Foundation

struct CatalogResponse: Codable {
    let greeting: String?
    let instructions: [String]?
    let collection: Collection?
}

// MARK: - Collection
struct Collection: Codable {
    let version: String
    let links: [CollectionLink]
    let metadata: Metadata
    let href: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let href: String
    let data: [ItemData]
    let links: [ItemLink]
}

// MARK: - itemData
struct ItemData: Codable {
    let itemDescription, nasaID: String
    let mediaType: MediaType
    let title: String
    let dateCreated: Date
    let photographer: String?
    let keywords: [String]?
    let center: Center
    let secondaryCreator, description508, location: String?
    let album: [String]?

    enum CodingKeys: String, CodingKey {
        case itemDescription = "description"
        case nasaID = "nasa_id"
        case mediaType = "media_type"
        case title
        case dateCreated = "date_created"
        case photographer, keywords, center
        case secondaryCreator = "secondary_creator"
        case description508 = "description_508"
        case location, album
    }
}

enum Center: String, Codable {
    case afrc = "AFRC"
    case arc = "ARC"
    case gsfc = "GSFC"
    case hq = "HQ"
    case jpl = "JPL"
    case jsc = "JSC"
    case ksc = "KSC"
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let rel: Rel
    let href: String
    let render: MediaType?
}

enum Rel: String, Codable {
    case captions = "captions"
    case preview = "preview"
}

// MARK: - CollectionLink
struct CollectionLink: Codable {
    let rel, prompt: String
    let href: String
}

// MARK: - Metadata
struct Metadata: Codable {
    let totalHits: Int

    enum CodingKeys: String, CodingKey {
        case totalHits = "total_hits"
    }
}
