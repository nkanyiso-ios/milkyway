import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Outlet(s)
    @IBOutlet private weak var catalogTable: UITableView! {
        didSet {
            catalogTable.dataSource = self
            catalogTable.delegate = self
            catalogTable.separatorStyle = .none
        }
    }
    
    // MARK: - Private properties
    private lazy var viewModel = HomeViewModel()
    private var cancellable: AnyCancellable?
    private var imagecancell: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("The Milky Way", comment: "")
        viewModel.getCatalogImage()
        observeViewModelState()
    }
    
    private func observeViewModelState(){
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
            bind(to: itemData,cell: cell)
        }
        if let urlString =  viewModel.catalogFor(indexPath.row)?.links[0].href {
            guard let url = URL(string: urlString) else {
                return cell
            }
            cell.startAnimating()
            viewModel.downloadImage(imageUrl: url).sink(receiveValue: { image in
                cell.stopAnimating()
                if (image != nil){
                    DispatchQueue.main.async { cell.updateImage(image ?? UIImage()) }
                }
            }).store(in: &imagecancell)
        }
        return cell
    }
    
    private func bind(to catalogImageData: ItemData, cell: CatalogCell) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = App.dateFormat
        cell.configure(catalogImageData.title,
                       nameDate: (catalogImageData.photographer ?? "") + " | " + dateFormatter.string(from: catalogImageData.dateCreated))
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = catalogTable.indexPathForSelectedRow else { return }
        
        if let target = segue.destination as? DetailViewController {
            if let item = viewModel.catalogFor(selectedPath.row) {
                target.catalogData =  item
            }
        }
    }
}

