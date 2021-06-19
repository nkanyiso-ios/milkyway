
import Combine

class HomeViewModel: ObservableObject {
    // MARK:- Private properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let client = Client()
    private var searchResults: CatalogResponse?
    
    
    @Published var state = State.idle
    
    func getCatalogImage() {
        state = .fetching
        
        let request = GetAllCatalogImagesRequest()
        client.publisherForRequest(request)
            .sink(receiveCompletion: { [weak self] result in
                
                switch result {
                case .finished:
                    if (self?.searchResults?.collection?.items.count ?? 0) > 0 { self?.state = .fetched }
                    else { self?.state = .error(APIError.noDataFound) }
                case .failure(let error):
                    self?.state = .error(error)
                }
            }, receiveValue: { [weak self] catalogResponse in
                self?.searchResults = catalogResponse
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Internal/Exposure functions
    
    func catalogCount() -> Int { searchResults?.collection?.items.count ?? 0 }
    func catalogFor(_ row: Int) -> Item? { searchResults?.collection?.items[row] }
    
}
