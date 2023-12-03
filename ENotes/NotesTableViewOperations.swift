//
//  NotesTableViewOperations.swift
//  ENotes
//

import Foundation

import  UIKit
protocol NotesTableViewCellDelegate{
    func notesClicked(index:Int)
}



class NotesTableViewCell: UITableViewCell {
    //MARK:- Static Variables
    static let cellIdentifier:String = "NotesTableViewCell"
    
    //MARK:-  Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    var delegate:NotesTableViewCellDelegate?
    var index:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:NotesMainListEntity,index:Int){
        self.index = index
        
        self.lblTitle.text = data.tile
        self.lblContent.text = data.content
        self.btnSelect.removeTarget(self, action: nil, for: .allEvents)
        self.btnSelect.addTarget(self, action: #selector(NotesTableViewCell.selectContact(_:)), for: .touchUpInside)
    }
    
    
    @objc func selectContact(_ sender: Any) {
        self.delegate?.notesClicked(index: self.index)
        
    }
}
