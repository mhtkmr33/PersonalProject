import Foundation
import UIKit

enum CustomFilterKeys: String {
    case and
    case or
    case above
    case below
}

protocol CellPhoneViewModelDelegate: class {
    func refreshHomeScreen(response: CellPhoneResponse)
}

protocol CellPhoneViewModelProtocol {
    func fetchPhones()
    var delegate: CellPhoneViewModelDelegate? { get set }
    func filterResults(searchText: String, dataSource: [CellPhone]) -> [CellPhone]
}

class CellPhoneViewModelImpl: CellPhoneViewModelProtocol {

    weak var delegate: CellPhoneViewModelDelegate?
    private let operationHandler: SmartServBehaviourProvider
    
    
    init(operationHandler: SmartServBehaviourProvider = SmartServOperationsHandler()) {
        self.operationHandler = operationHandler
        fetchPhones()
    }

    func fetchPhones() {
        operationHandler.delegate = self
        operationHandler.fetch()
    }

    func filterResults(searchText: String, dataSource: [CellPhone]) -> [CellPhone] {
        var filteredArray = [CellPhone]()
        let lowerCaseSearchText = searchText.lowercased()
        var searchedQueryWords = [String]()
        let separatedCharacters = lowerCaseSearchText.components(separatedBy: " ")
        if separatedCharacters.count > 0 {
            for words in separatedCharacters {
                if words == CustomFilterKeys.and.rawValue || words == CustomFilterKeys.or.rawValue {
                    //do nothing
                } else {
                    searchedQueryWords.append(words)
                }
            }
            for (index,query) in searchedQueryWords.enumerated() {
                filteredArray += dataSource.filter({ $0.title.lowercased().contains(query)})
                if searchedQueryWords[index] == CustomFilterKeys.above.rawValue || searchedQueryWords[index] == CustomFilterKeys.below.rawValue {
                    let incrementedIndex = index + 1
                    if incrementedIndex < searchedQueryWords.count {
                        let nextValue = (searchedQueryWords[index + 1] as NSString).doubleValue
                        if searchedQueryWords[index] == CustomFilterKeys.above.rawValue {
                            filteredArray = filteredArray.filter({($0.price as NSString).doubleValue > nextValue})
                        } else {
                            filteredArray = filteredArray.filter({($0.price as NSString).doubleValue < nextValue})
                        }
                        
                    }
                }
            }
        }
        return filteredArray
    }
}

extension CellPhoneViewModelImpl: SmartServDelegate {
    func reposne(data: CellPhoneResponse) {
        delegate?.refreshHomeScreen(response: data)
    }
}

