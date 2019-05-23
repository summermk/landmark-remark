//
//  SearchViewController.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 21/05/19.
//  Copyright (c) 2019 mira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchDisplayLogic: class
{
    func displayNotes(viewModel: [NoteCellModel])
    func displaySearchResults(viewModel: [NoteCellModel])
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  /// Clean architecture components setup
  private func setup()
  {
    let viewController = self
    let interactor = SearchInteractor()
    let presenter = SearchPresenter()
    let router = SearchRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let identifier = segue.identifier, identifier == "unwindSegueToMap" {
        router?.routeUnwindToMap(segue: segue)
    }
  }
  
  // MARK: View lifecycle
  
    /// Search controller is initialised and programatically added at `viewDidLoad()`
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Set the title to Search
        title = LocalizedString.get(ScreenTitle.search)
        
        // Initialise the table view and search bar
        configureTableView()
        configureSearchController()
        
        // Get the notes so we can locally cache them for search
        // Ideally we only want to show the search results but for simplicity
        // we show the whole list then filter out the list as user types
        // in the sesarch bar
        interactor?.getNotes()
    }
    
    /// Set the table view delegate and data source to `self`
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    /**
        Set up the search controller and add to navigation bar.

        Search controller in the navigation bar is only supported from iOS 11 onwards
        so a workaround is done for iOS 10 to show the search bar in table header instead.
     */
    private func configureSearchController() {
        // This sets means we can decide what to show in search results as it updates
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedString.get(TextPlaceholder.search)
        
        // This shows search inside the navigation bar which is only available in iOS 11 and later.
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions.
            // Show the search bar in table view header instead.
            searchController.hidesNavigationBarDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.isActive = true
    }
    
    
    
    // MARK: - SearchDisplayLogic
  
    @IBOutlet weak var tableView: UITableView!
    var allNotes = [NoteCellModel]()
    var searchResults = [NoteCellModel]()
    
    /**
        Update the model for notes list
   
        This doesn't directly show the list but instead requests
        the table view to reload the data.
     */
    func displayNotes(viewModel: [NoteCellModel]) {
        allNotes = viewModel
        tableView.reloadData()
    }
    
    /**
        Update the model for search results
    
        This doesn't directly show the list but instead requests
        the table view to reload the data.
     */
    func displaySearchResults(viewModel: [NoteCellModel]) {
        searchResults = viewModel
        tableView.reloadData()
    }
    
    /**
        Abort any current work and close search view.
 
        Triggered by X button on the top left corner.
    */
    @IBAction func closeSearch(_ sender: Any) {
        //
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper methods
    
    /// Returns true if the text is empty or nil
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns true if search is active
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    /**
        Filters the note by searching for text in notes and username.
     
        Search is not case sensitive.
     */
    func filterNotes(searchText: String?) {
        guard let searchText = searchText else {
            searchResults = [NoteCellModel]()
            return
        }
        
        searchResults = allNotes.filter({ (note: NoteCellModel) -> Bool in
            // search for both notes and username
            return (note.title.lowercased().contains(searchText.lowercased()) || note.subtitle.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }

}

// MARK: - Table view data source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show the search results if the search filter is active
        if isFiltering() {
            return searchResults.count
        }
        
        // Otherwise show the whole list of notes
        return allNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = getTableViewModel(atIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = "\(model.subtitle) at (\(model.latitude),\(model.longitude))"
        
        return cell
    }
    
    // Helper method
    fileprivate func getTableViewModel(atIndexPath indexPath: IndexPath) -> NoteCellModel {
        let model: NoteCellModel
        
        if isFiltering() {
            // Show the search results if the search filter is active
            model = searchResults[indexPath.row]
        } else {
            // Otherwise show all notes
            model = allNotes[indexPath.row]
        }
        
        return model
    }
    
}


// MARK: - Table view delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = getTableViewModel(atIndexPath: indexPath)
        interactor?.selectedNote(model)
        performSegue(withIdentifier: "unwindSegueToMap", sender: self)
    }
}


// MARK: - Search controller
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterNotes(searchText: searchController.searchBar.text)
    }
}