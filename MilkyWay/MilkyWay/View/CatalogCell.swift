
import UIKit

class CatalogCell: UITableViewCell {
    // MARK: - private Outlet(s)
    
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var nameDate: UILabel!
    
    let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Exposed/Internal functions
    
    func configure(_ title: String, nameDate: String) {
        self.nameDate.text = nameDate
        self.title.text = title
    }
    
    func updateImage(_ image: UIImage) { thumbnail.image = image }
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = #imageLiteral(resourceName: "place_holder")
        
    }
    func startAnimating() {
        
        activityIndicator.color = .darkGray
        DispatchQueue.main.async {
            self.thumbnail.addSubview(self.activityIndicator)
            self.activityIndicator.center = self.thumbnail.center
            self.activityIndicator.startAnimating()
        }
    }
    func stopAnimating(){
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
}
