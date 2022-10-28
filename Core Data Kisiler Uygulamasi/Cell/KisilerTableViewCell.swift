//
//  KisilerTableViewCell.swift
//  Core Data Kisiler Uygulamasi
//
//  Created by Seyfullah Daldal on 20.09.2022.
//

import UIKit

class KisilerTableViewCell: UITableViewCell {

    @IBOutlet weak var kisiImageView: UIImageView!
    @IBOutlet weak var kisiNumaraLabel: UILabel!
    @IBOutlet weak var kisiAdLabel: UILabel!
    @IBOutlet weak var kisiMailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        
    }

}
