//
//  AudioCell.swift
//  RecordAudio
//
//  Created by Krishna Gunjal on 27/02/23.
//

import UIKit

class AudioCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var buttonTapCallback: () -> ()  = { }
    
    static let identifier = "AudioCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    @IBAction func didTapButton() {
        buttonTapCallback()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
