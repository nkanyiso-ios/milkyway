import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: - Outlet(s)
    @IBOutlet private weak var catalogImage: UIImageView!
    @IBOutlet private weak var imageTitle: UILabel!
    @IBOutlet private weak var imageNameDate: UILabel!
    @IBOutlet private weak var imageDescription: UITextView!
    
    // MARK: - Private properties
    private lazy var viewModel = HomeViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    var catalogData: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
    }
    
    private func updateDisplay(){
        guard let item = catalogData, let data = catalogData?.data.first else { self.showAlert(alertText: "Error", alertMessage: NSLocalizedString("Sorry no data found.", comment: ""))
            return
        }
        
        imageTitle.text = data.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = App.dateFormat
        imageNameDate.text = (data.photographer ?? "") + " | " + dateFormatter.string(from: data.dateCreated)
        imageDescription.text = data.itemDescription
        imageDescription.textContainer.lineFragmentPadding = 0
        guard let url = URL(string: item.links.first?.href ?? "" ) else { return }
        
        viewModel.downloadImage(imageUrl: url).sink(receiveValue: { image in
            if image != nil { DispatchQueue.main.async { self.catalogImage.image = image } }
        }).store(in: &cancellable)
    }
}
