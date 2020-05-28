import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: [CellPhone] = []
    private var viewModel: CellPhoneViewModelProtocol?
    var searchResultsVC: SearchResultsViewController?
    var filteredArray: [CellPhone] = []
    var isFiltered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Phones"
        viewModel = CellPhoneViewModelImpl()
        viewModel?.delegate = self
        manageIndcator(shouldShow: true)
        setUpSearchBarController()
        textField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func searchTapped(_ sender: Any) {
        guard let searchText = textField.text,
        let phonesViewModel = viewModel else { return }
        isFiltered = true
        filteredArray = phonesViewModel.filterResults(searchText: searchText, dataSource: self.dataSource)
        tableView.reloadData()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 0 {
            isFiltered = false
        }
        tableView.reloadData()
    }
    
    private func setUpSearchBarController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            searchResultsVC = storyBoard.instantiateViewController(identifier: "SearchResultsViewController")
        } else {
            searchResultsVC = storyBoard.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController
        }
        let searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = searchResultsVC
        searchController.searchBar.placeholder = "Search for phones"
        navigationItem.searchController = searchController
    }

    private func manageIndcator(shouldShow: Bool) {
        if shouldShow {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFiltered ? filteredArray.count : dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: DesignConstants.tableViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: DesignConstants.tableViewCellIdentifier)
        }
        let dataSourceForIndexPath = isFiltered ? filteredArray[indexPath.row] : dataSource[indexPath.row]
        cell?.textLabel?.text = "Title: \(dataSourceForIndexPath.title)"
        cell?.detailTextLabel?.text = "Price: \(dataSourceForIndexPath.price) and Popularity: \(dataSourceForIndexPath.popularity)"
        return cell ?? UITableViewCell()
    }
}

extension ViewController: CellPhoneViewModelDelegate {
    func refreshHomeScreen(response: CellPhoneResponse) {
        switch response {
        case .gotDataSucessfully(let cellPhoneData):
            DispatchQueue.main.async {
                self.dataSource = cellPhoneData
                self.tableView.reloadData()
                self.manageIndcator(shouldShow: false)
            }
            searchResultsVC?.dataSource = cellPhoneData
        case.failToGetData(let error):
            print("Error", error)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
}


private struct DesignConstants {
    static let tableViewCellIdentifier = "tableCell"
}
