//
//  ListProjectsViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class ListFlowchartViewController: UIViewController {
    @IBOutlet var listFlowchartsView: ListFlowchartView!
    
    var flowcharts: [Flowchart] = [
        Flowchart(flowchartName: "Flowchart For Login", date: "07/06/21"),
        Flowchart(flowchartName: "Flowchart Auth", date: "06/06/21"),
        Flowchart(flowchartName: "Project Sync Data", date: "05/06/21"),
        Flowchart(flowchartName: "Project D", date: "04/06/21"),
        Flowchart(flowchartName: "Project E", date: "03/06/21"),
        Flowchart(flowchartName: "Project F", date: "02/06/21"),
        Flowchart(flowchartName: "Project G", date: "01/06/21"),
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult: [(Flowchart)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        listFlowchartsView.tableView.delegate = self
        listFlowchartsView.tableView.dataSource = self
        listFlowchartsView.tableView.tableFooterView = UIView()
        
        // Search Component
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        listFlowchartsView.tableView.tableHeaderView = searchController.searchBar
        listFlowchartsView.tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc func deleteTapped(indexData: Int){
        let alertController = UIAlertController(title: "Action Sheet", message: "Are you sure want to delete this project?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            print("\(self.flowcharts[indexData]) Deleted!")
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

extension ListFlowchartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResult.count : flowcharts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flowchart = searchController.isActive ?  searchResult[indexPath.row] : flowcharts[indexPath.row]
        
        let cell = listFlowchartsView.tableView.dequeueReusableCell(withIdentifier: "flowchartCell", for: indexPath)
        cell.textLabel?.text = flowchart.flowchartName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = flowchart.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = searchController.isActive ? searchResult[indexPath.row] : flowcharts[indexPath.row]
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
            guard let flowchart = sender as? Flowchart else {
                return
            }
            
            destinationVC.idFlowchart = flowchart.id
            destinationVC.titleFlowchart = flowchart.flowchartName
            
        }
    }
    
}

extension ListFlowchartViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            
            searchController.obscuresBackgroundDuringPresentation = false
            listFlowchartsView.tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        searchResult = flowcharts.filter({ data -> Bool in
            let match = data.flowchartName.range(of: searchText, options: .caseInsensitive)
            
            return match != nil
        })
    }
}
