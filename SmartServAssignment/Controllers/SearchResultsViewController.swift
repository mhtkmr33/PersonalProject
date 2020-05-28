import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [CellPhone]()
    var filteredArray = [CellPhone]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DesignConstants.tableViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: DesignConstants.tableViewCellIdentifier)
        }
        let dataSourceForIndexPath = filteredArray[indexPath.row]
        cell?.textLabel?.text = "Title: \(dataSourceForIndexPath.title)"
        cell?.detailTextLabel?.text = "Price: \(dataSourceForIndexPath.price)"
        return cell ?? UITableViewCell()
    }
}


extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredArray = dataSource.filter({$0.title.lowercased().contains(searchText.lowercased())})
        }
        tableView.reloadData()
    }
}

private struct DesignConstants {
    static let tableViewCellIdentifier = "searchResultsCell"
}
