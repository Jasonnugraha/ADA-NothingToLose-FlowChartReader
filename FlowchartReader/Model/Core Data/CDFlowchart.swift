//
//  CDFlowchart.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 16/06/21.
//

import UIKit
import CoreData

class CDFlowchart {
    //    var flowchartFile : FlowchartDetailwithID?
    //    var flowchartDetails : [FlowchartFile]?
    var appDelegate : AppDelegate?
    var manageObjectContext : NSManagedObjectContext?
    
    
    init() {
        connect()
    }
    
    func connect() {
        if manageObjectContext == nil {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            manageObjectContext = appDelegate?.persistentContainer.viewContext
        }
    }
    
    func getAllFlowchartFile() -> [CDFlowchartFile] {
        //return all flowchartfile (untuk table isi semua file)
        connect()
        var data = [CDFlowchartFile] ()
        let arrData = NSFetchRequest<CDFlowchartFile>(entityName: "CDFlowchartFile")
        let sortBy = NSSortDescriptor.init(key: "tanggal", ascending: true)
        arrData.sortDescriptors = [sortBy]
        
        do {
            data = try (manageObjectContext?.fetch(arrData))!
            
            print(data.count)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return data
    }
    
    func appendFlowchartFile(pFlowchartID: UUID, pFlowchartName: String, pfilePath: String ) {
        // add new flowchart file
        connect()
        
        let data = CDFlowchartFile(context: manageObjectContext!)
        data.flowchartID = pFlowchartID
        data.filePath = pFlowchartName
        data.tanggal = Date()
        data.flowchartName = pFlowchartName
        
        do {
            try manageObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteFlowchartFile(pID: String) {
        //delete flowchart file based on id
    }
    
    func getAllFlowchartDetail(pFlowchartID : UUID) -> [CDFlowchartDetail] {
        //return all flowchart detail // array of struck , flowchartid: uuid
        connect()
        var data = [CDFlowchartDetail] ()
        let arrData = NSFetchRequest<CDFlowchartDetail>(entityName: "CDFlowchartDetail")
        let sortBy = NSSortDescriptor.init(key: "id", ascending: true)
        arrData.sortDescriptors = [sortBy]
        arrData.predicate = NSPredicate.init(format: "flowchartId == %@", pFlowchartID.uuidString)
        
        do {
            data = try (manageObjectContext?.fetch(arrData))!
            
            print(data.count)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return data
    }
    
    func appendFlowchartDetails(pFlowchartID: UUID, pFlowchartDetails : [FlowchartDetail]) {
        // add array of flowchartDetail. Tidak simpan satu2 tetapi langsung 1 skenario
        connect()
        for i in 0..<pFlowchartDetails.count {
            let data = CDFlowchartDetail(context: manageObjectContext!)
            data.flowchartID = pFlowchartID
            data.id = Int16(pFlowchartDetails[i].id)
            data.down = Int16(pFlowchartDetails[i].down)
            data.left = Int16(pFlowchartDetails[i].left)
            data.right = Int16(pFlowchartDetails[i].right)
            data.shape = pFlowchartDetails[i].shape
            data.text = pFlowchartDetails[i].text
        }
        
        do {
            try manageObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}
