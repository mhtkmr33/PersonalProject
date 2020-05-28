import Foundation

protocol ServiceHelperProtocol {
    func request<T>(endPoints: EndPointType, completion: @escaping((Result<T, Error>) -> Void)) where T: Decodable
}

final class HTTPRequestHandler: ServiceHelperProtocol {
    
    func request<T>(endPoints: EndPointType, completion: @escaping((Result<T, Error>) -> Void)) where T: Decodable {
        guard let request = buildRequest(route: endPoints) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataFromApi = data,
                error == nil,
                let dataModel = try? JSONDecoder().decode(T.self, from: dataFromApi) else {
                    completion(.failure(error!))
                    return
            }
            completion(.success(dataModel))
        }.resume()
    }

    private func buildRequest(route: EndPointType) -> URLRequest? {
        switch route.taskType {
        case .getRequest(let parameters):
            return buildGetRequest(route: route, parameters: parameters)
        case .postRequest(let parameters, let headers):
            return getPostRequest(route: route, parameters: parameters, headers: headers)
        }
    }

    private func buildGetRequest(route: EndPointType, parameters: [String: Any]?) -> URLRequest? {
        guard var component = URLComponents(string: route.baseURL) else { return nil }
        component.queryItems = [URLQueryItem]()
        component.path = route.path
        if let params = parameters {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                component.queryItems?.append(queryItem)
            }
        }
        guard let url = component.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        request.httpMethod = route.httpMethod.rawValue
        return request
    }

    private func getPostRequest(route: EndPointType, parameters: [String: Any]?, headers: [String: Any]?) -> URLRequest? {
        guard let baseURL = URL(string: route.baseURL) else { return nil }
        var request = URLRequest(url: baseURL.appendingPathComponent(route.path), cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        
        if let headerFields = headers {
            for (key, value) in headerFields {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        if let parameterFields = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameterFields, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            } catch {
                return nil
            }
        }
        return request
    }
}
