
import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Outlet(s)
    @IBOutlet weak var catalogTable: UITableView! {
        didSet {
            catalogTable.dataSource = self
            catalogTable.delegate = self
            catalogTable.separatorStyle = .none
        }
    }
    
    // MARK: - Private properties
    
    private lazy var viewModel = HomeViewModel()
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Home title", comment: "")
        viewModel.getCatalogImage()
        observeViewModelState()
    }
    
    func observeViewModelState(){
        cancellable = viewModel.$state.sink(receiveValue: {[weak self] state in
            switch state {
            
            case .idle:break
            case .fetching:
                self?.view.activityStartAnimating(activityColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
            case .fetched:
                self?.view.activityStopAnimating()
                self?.catalogTable.reloadData()
            case .error(let error):
                self?.showAlert(alertText: "Error", alertMessage: error.localizedDescription)
                self?.view.activityStopAnimating()
            }
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.catalogCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = catalogTable.dequeueReusableCell(withIdentifier: "catalogCell") as? CatalogCell else { return UITableViewCell() }
        
        if let itemData = viewModel.catalogFor(indexPath.row)?.data[0]{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = App.dateFormat
            cell.title.text = itemData.title
            cell.nameDate.text = (itemData.photographer ?? "") + " | " + dateFormatter.string(from: itemData.dateCreated)
        }
        
        return cell
    }
    
    
}

