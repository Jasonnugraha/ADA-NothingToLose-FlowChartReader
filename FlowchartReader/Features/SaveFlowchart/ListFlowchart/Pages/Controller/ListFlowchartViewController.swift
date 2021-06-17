//
//  ListProjectsViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class ListFlowchartViewController: UIViewController {
//    var flowchartDetails = [
//        FlowchartDetail(id: 0, shape: "Teriminator", text: "Start", down: 1, right: -1, left: -1),
//        FlowchartDetail(id: 1, shape: "Process", text: "Open a Book", down: 2, right: -1, left: -1),
//        FlowchartDetail(id: 2, shape: "Decision", text: "Favourite Book", down: -1, right: 4, left: 3),
//        FlowchartDetail(id: 3, shape: "Process", text: "Close The Book", down: 5, right: -1, left: -1),
//        FlowchartDetail(id: 4, shape: "Process", text: "Read The Book", down: 3, right: -1, left: -1),
//        FlowchartDetail(id: 5, shape: "Teriminator", text: "End", down: -2, right: -1, left: -1),
//    ]
//    let service = FlowchartStructureService()
    //-------
    @IBOutlet var listFlowchartsView: ListFlowchartView!
    
    var flowcharts = [CDFlowchartFile]()
    
    var helper = Helper()
    
    let modelService = CDFlowchart()
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult: [(CDFlowchartFile)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        var id = UUID()
//////
//        var fileName = self.service.save(image: UIImage(named: "FavBook")!, fileName: "G_\(id)") // For Dev
//        self.modelService.appendFlowchartFile(pFlowchartID: id, pFlowchartName: "G", pfilePath: "G_\(id)")
//        self.modelService.appendFlowchartDetails(pFlowchartID: id, pFlowchartDetails: flowchartDetails)

        // ----
        flowcharts = modelService.getAllFlowchartFile()
        
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
        let alertController = UIAlertController(title: "Action Sheet", message: "Are you sure want to delete this flowchart?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            self.modelService.deleteFlowchartFile(pID: self.flowcharts[indexData].flowchartID!)
            DispatchQueue.main.async {
                self.flowcharts.remove(at: indexData)
                self.listFlowchartsView.tableView.reloadData()
            }
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
        let flowchart = searchController.isActive ? searchResult[indexPath.row] : flowcharts[indexPath.row]
        
        let cell = listFlowchartsView.tableView.dequeueReusableCell(withIdentifier: "flowchartCell", for: indexPath)
        cell.textLabel?.text = flowchart.flowchartName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        if let date = flowchart.tanggal {
            cell.detailTextLabel?.text = "\(helper.dateFormater(dateData: date))"
        }
        
//        print("\(cell.textLabel?.text) - \(cell.detailTextLabel?.text)")
        
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
            guard let flowchart = sender as? CDFlowchartFile else {
                return
            }
            destinationVC.idFlowchart = flowchart.flowchartID
            
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
            let match = data.flowchartName!.range(of: searchText, options: .caseInsensitive)
            
            return match != nil
        })
    }
}
