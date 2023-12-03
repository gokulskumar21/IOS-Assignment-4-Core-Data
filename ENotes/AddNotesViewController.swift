//
//  AddNotesViewController.swift
//  ENotes
//

import UIKit

class AddNotesViewController: UIViewController {
    
    
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "AddNotesViewController"
    var addOperation:Bool = true
    
    @IBOutlet weak var btnAdd: UIButton!
    var currentNoteObj:NotesMainListEntity? = nil
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTxtView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentData()
        // Do any additional setup after loading the view.
    }
    
    func setCurrentData(){
        
        if currentNoteObj != nil {
            self.titleTextField.text = currentNoteObj?.tile
            self.contentTxtView.text = currentNoteObj?.content
            self.btnAdd.setTitle("Update", for: .normal)
            self.addOperation = false
        }
        else{
            self.btnAdd.setTitle("Add", for: .normal)
            self.addOperation = true
        }
      
    }
    class func showaddNoteViewPage(sourceView:UIViewController,selectedModel:NotesMainListEntity?){
        let storyboard = UIStoryboard(name: AddNotesViewController.storyboardName, bundle: nil)
        let detailiewVC:AddNotesViewController = storyboard.instantiateViewController(withIdentifier: AddNotesViewController.storyBoardId) as! AddNotesViewController
        detailiewVC.currentNoteObj = selectedModel
        sourceView.navigationController?.isNavigationBarHidden = false
        sourceView.navigationController?.pushViewController(detailiewVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addOrUpdateNotes(_ sender: Any) {
        
        let titleTxt = titleTextField.text ?? ""
        if titleTxt == "" {
           return
        }

        let contentTxt = contentTxtView.text ?? ""
        if contentTxtView.text == "" {
            return
        }
     
        if !addOperation {
            //UPD
            QCCoredataOperations().updateRecordBy(title: titleTxt, Content: contentTxt,id: currentNoteObj?.id ?? "") { [self] result in
                if result {
                    
                    self.showAlert(status: result)
                    
                   
                }
            }
        }
        else{
            //ADD
            QCCoredataOperations().saveNote(title: titleTxt, content: contentTxt) { resultItem in
                self.showAlert(status: true)
            }
        }
       
    }
    func showAlert(status:Bool
    ){
        var msg = ""
        if status {
            if addOperation {
                msg = "Notes added."
            }
            else{
                msg = "Notes Updted."
            }
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
    func popUpView(action:UIAlertAction) {
        self.navigationController?.popViewController(animated: true)
    }
}
