import XCTest
@testable import SmartServAssignment

class CellPhoneViewModelImplTests: XCTestCase {

    func testFilterResultsForAndCustomFilter() {
        let customFilterString = "Samsung and iphone"
        let viewModel = CellPhoneViewModelImpl(operationHandler: MockSmartServOperationsHandler())
        let dummyPhoneOne = CellPhone(subcategory: "dummy", title: "iPhone", price: "30000", popularity: "1234")
        let dummyPhoneTwo = CellPhone(subcategory: "dummy", title: "Samsung", price: "40000", popularity: "1454")
        let phoneDataSource: [CellPhone] = [dummyPhoneOne, dummyPhoneTwo]
        let filteredResult = viewModel.filterResults(searchText: customFilterString,
                                                     dataSource: phoneDataSource)
        XCTAssertEqual(2, filteredResult.count)
    }

    func testFilterResultsForORCustomFilter() {
        let customFilterString = "Samsung or iphone"
        let viewModel = CellPhoneViewModelImpl(operationHandler: MockSmartServOperationsHandler())
        let dummyPhoneOne = CellPhone(subcategory: "dummy", title: "iPhone", price: "30000", popularity: "1234")
        let dummyPhoneTwo = CellPhone(subcategory: "dummy", title: "Samsung", price: "40000", popularity: "1454")
        let phoneDataSource: [CellPhone] = [dummyPhoneOne, dummyPhoneTwo]
        let filteredResult = viewModel.filterResults(searchText: customFilterString,
                                                     dataSource: phoneDataSource)
        XCTAssertEqual(2, filteredResult.count)
    }

    func testFilterResultsForAboveCustomFilter() {
        let customFilterString = "iphone above 50000"
        let viewModel = CellPhoneViewModelImpl(operationHandler: MockSmartServOperationsHandler())
        let dummyPhoneOne = CellPhone(subcategory: "dummy", title: "iPhone", price: "41000", popularity: "1234")
        let dummyPhoneTwo = CellPhone(subcategory: "dummy", title: "Samsung", price: "20000", popularity: "1454")
        let dummyPhoneThree = CellPhone(subcategory: "dummy", title: "iPhone", price: "42000", popularity: "1234")
        let dummyPhoneFour = CellPhone(subcategory: "dummy", title: "iPhone", price: "51000", popularity: "1234")
        let phoneDataSource: [CellPhone] = [dummyPhoneOne, dummyPhoneTwo, dummyPhoneThree, dummyPhoneFour]
        let filteredResult = viewModel.filterResults(searchText: customFilterString,
                                                     dataSource: phoneDataSource)
        XCTAssertEqual(1, filteredResult.count)
    }

    func testFilterResultsForBelowCustomFilter() {
        let customFilterString = "iphone and samsung below 30000"
        let viewModel = CellPhoneViewModelImpl(operationHandler: MockSmartServOperationsHandler())
        let dummyPhoneOne = CellPhone(subcategory: "dummy", title: "iPhone", price: "41000", popularity: "1234")
        let dummyPhoneTwo = CellPhone(subcategory: "dummy", title: "Samsung", price: "20000", popularity: "1454")
        let dummyPhoneThree = CellPhone(subcategory: "dummy", title: "iPhone", price: "25000", popularity: "1234")
        let dummyPhoneFour = CellPhone(subcategory: "dummy", title: "iPhone", price: "50000", popularity: "1234")
        let phoneDataSource: [CellPhone] = [dummyPhoneOne, dummyPhoneTwo, dummyPhoneThree, dummyPhoneFour]
        let filteredResult = viewModel.filterResults(searchText: customFilterString,
                                                     dataSource: phoneDataSource)
        XCTAssertEqual(2, filteredResult.count)
    }

}

class MockSmartServOperationsHandler: SmartServBehaviourProvider {
    func fetch() {}
    var delegate: SmartServDelegate? = nil
}
