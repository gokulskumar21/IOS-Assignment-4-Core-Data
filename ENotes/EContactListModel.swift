//
//  EContactListModel.swift
//  ENotes
//

import Foundation
struct NotesMainListEntity  {
    var tile : String = ""
    var content : String = ""
    var dateTime : Date = Date()
    var id:String = ""
    
    init() {
        tile = ""
        content = ""
        dateTime = Date()
        id = ""
    }
    
    func getNoteList(completion:@escaping (_ status:Bool ,_ message :String, _ result: [NotesMainListEntity] )->Void){
        
        QCCoredataOperations().getAllNoteList() {  dbContactResult in
            
            let noteListModel :[NotesMainListEntity] = convertToViewModel(list: dbContactResult)
            completion(false, "",noteListModel)
        }
    }
    
    func convertToViewModel(list:[NoteMaster])->[NotesMainListEntity]{
        var tmpList:[NotesMainListEntity]  = []
        for item in list{
            var tmp:NotesMainListEntity = NotesMainListEntity()
            tmp.tile = item.title ?? ""
            tmp.content = item.content ?? ""
            tmp.dateTime = item.timeStamp ?? Date()
            tmp.id =  item.id ?? ""
            tmpList.append(tmp)
        }
        return tmpList
    }
}
