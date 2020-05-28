import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var taskType: HTTPTaskType { get }
}

struct ServiceEndPointCreator: EndPointType {
    var baseURL: String
    var path: String
    var httpMethod: HTTPMethod
    var taskType: HTTPTaskType
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPTaskType {
    case getRequest(parameters: [String: Any]?)
    case postRequest(parameters: [String: Any]?, headers: [String: Any]?)
}
