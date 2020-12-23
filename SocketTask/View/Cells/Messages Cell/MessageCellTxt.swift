//
//  MessageCellTxt.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 23/12/2020.
//

import UIKit

class MessageCellTxt: UITableViewCell {

    @IBOutlet weak var msgLbl: UILabel!
    
    func cellConfigure(msg: Datum) {
        self.msgLbl.text = msg.content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
