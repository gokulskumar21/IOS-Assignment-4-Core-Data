//
//  ViewController.swift
//  ENotes
//
//  Created by Gokul on 2023-11-28.
//

import UIKit

class ViewController: UIViewController {

    
    //STATIC VARIABLES
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "ViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var noteMainModelList : [NotesMainListEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
    }
    func initialSetup(){
        self.fetchNotesDetails()
    }
    
    func fetchNotesDetails(){
       NotesMainListEntity().getNoteList { [weak self] status, msg , result in
            // print(self.contactMainModel.contactListModel.contactMainList.count)
           self?.noteMainModelList = result
            self?.tableReload()
        }
    }
    
    //RELOAD DATA
    func tableReload(){
        if self.noteMainModelList .count > 0{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
          
        }
        else{
            // self.noDataFoundLabel.text = SPMlcQuickContactsOperations.noDataFoundVal
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func AddNoteBtnClicked(_ sender: Any) {
        AddNotesViewController.showaddNoteViewPage(sourceView: self, selectedModel:nil)
    }
    func popUpView(action:UIAlertAction) {
        DispatchQueue.main.async {
            self.fetchNotesDetails()}
    }
      
    func showAlert(status:Bool){
        var msg = ""
        if status {
            
                msg = "Notes deleted."
            }
           
        else{
            msg = "Transaction failed"
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ENotes", message: msg, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: self.popUpView))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}




extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.noteMainModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.cellIdentifier) as? NotesTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.setData(data: self.noteMainModelList[indexPath.row], index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            QCCoredataOperations().deleteAllRecordsByTimeStamp(id: self.noteMainModelList[indexPath.row].id) { [self] result in
                
                if result {
                    showAlert(status: result)
                }
               
              
            }
        }
    }
    
    
}

extension ViewController:NotesTableViewCellDelegate{
    func notesClicked(index: Int) {
        AddNotesViewController.showaddNoteViewPage(sourceView: self, selectedModel: self.noteMainModelList[index])
    }
      
    
}
