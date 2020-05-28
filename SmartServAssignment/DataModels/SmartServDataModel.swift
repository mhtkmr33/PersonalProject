import Foundation

struct CellPhone: Decodable {
    let subcategory: String
    let title: String
    let price: String
    let popularity: String
}

struct CellPhonesResponse: Decodable {
    var phones: [CellPhone]
    enum CodingKeys: String, CodingKey {
        case products = "products"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode([String: CellPhone].self, forKey: .products)
        phones = Array(data.values)
    }
}
