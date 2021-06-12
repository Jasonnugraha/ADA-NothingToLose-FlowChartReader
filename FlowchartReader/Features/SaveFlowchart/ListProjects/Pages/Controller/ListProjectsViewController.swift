//
//  ListProjectsViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class ListProjectsViewController: UIViewController {
    @IBOutlet var listProjectsView: ListProjectsView!
    
    var projects: [Project] = [
        Project(projectName: "Flowchart For Login", date: "07/06/21"),
        Project(projectName: "Flowchart Auth", date: "06/06/21"),
        Project(projectName: "Project Sync Data", date: "05/06/21"),
        Project(projectName: "Project D", date: "04/06/21"),
        Project(projectName: "Project E", date: "03/06/21"),
        Project(projectName: "Project F", date: "02/06/21"),
        Project(projectName: "Project G", date: "01/06/21"),
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult: [(Project)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        listProjectsView.tableView.delegate = self
        listProjectsView.tableView.dataSource = self
        listProjectsView.tableView.tableFooterView = UIView()
        
        // Search Component
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        listProjectsView.tableView.tableHeaderView = searchController.searchBar
        listProjectsView.tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc func deleteTapped(indexData: Int){
        let alertController = UIAlertController(title: "Action Sheet", message: "Are you sure want to delete this project?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            print("\(self.projects[indexData]) Deleted!")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
}

extension ListProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResult.count : projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = searchController.isActive ?  searchResult[indexPath.row] : projects[indexPath.row]
        
        let cell = listProjectsView.tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        cell.textLabel?.text = project.projectName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = project.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = searchController.isActive ? searchResult[indexPath.row] : projects[indexPath.row]
        performSegue(withIdentifier: "detailFlowchartSegue", sender: project)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.deleteTapped(indexData: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailFlowchartViewController {
            guard let project = sender as? Project else {
                return
            }
            
            destinationVC.idProject = project.id
            destinationVC.titleProject = project.projectName
            
        }
    }
    
}

extension ListProjectsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            
            searchController.obscuresBackgroundDuringPresentation = false
            listProjectsView.tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        searchResult = projects.filter({ data -> Bool in
            let match = data.projectName.range(of: searchText, options: .caseInsensitive)
            
            return match != nil
        })
    }
}
