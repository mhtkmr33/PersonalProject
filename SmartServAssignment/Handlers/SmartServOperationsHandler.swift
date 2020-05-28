import Foundation

enum CellPhoneResponse {
    case gotDataSucessfully(data: [CellPhone])
    case failToGetData(error: String)
}

protocol SmartServDelegate: class {
    func reposne(data: CellPhoneResponse)
}

protocol SmartServBehaviourProvider: class {
    func fetch()
    var delegate: SmartServDelegate? { get set }
}

class SmartServOperationsHandler: SmartServBehaviourProvider {
    private let storageHandler: StorageProtocol
    private let serviceHanlder: ServiceHelperProtocol

    weak var delegate: SmartServDelegate?
    
    init(storage: StorageProtocol = CoreDataHandler(),
         service: ServiceHelperProtocol = HTTPRequestHandler()) {
        storageHandler = storage
        serviceHanlder = service
    }

    func fetch() {
        getDataFromAPI { (apiResponse) in
            switch apiResponse {
            case .gotDataSucessfully(let phoneArray):
                self.saveDataInLocalStorage(cellPhones: phoneArray)
            case .failToGetData(let errorDescription):
                self.delegate?.reposne(data: .failToGetData(error: errorDescription))
            }
        }
    }

    private func fetchFromLocalStorage() -> [CellPhone] {
        return storageHandler.fetch()
    }

    private func saveDataInLocalStorage(cellPhones: [CellPhone]) {
        DispatchQueue.main.async {
            for phone in cellPhones {
                self.storageHandler.save(phone: phone)
            }
            self.delegate?.reposne(data: .gotDataSucessfully(data: self.fetchFromLocalStorage()))
        }
    }

    private func getDataFromAPI(completion: @escaping((CellPhoneResponse) -> Void)) {
        let serviceEndPointCreator = ServiceEndPointCreator(baseURL: ApiURls.baseURL,
                                                            path: ApiURls.cellPhoneURL,
                                                            httpMethod: .get,
                                                            taskType: .getRequest(parameters: nil))
        serviceHanlder.request(endPoints: serviceEndPointCreator) { (result: Result<CellPhonesResponse, Error>) in
            switch result {
            case .success(let cellPhoneModel):
                completion(.gotDataSucessfully(data: cellPhoneModel.phones))
            case .failure(let error):
                completion(.failToGetData(error: error.localizedDescription))
            }
        }
    }
}
