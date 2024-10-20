//
//  SepetHucre.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 9.10.2024.
//

import UIKit

protocol HucreProtocol {
    func sepetiArtırTıklandı(indexPath:IndexPath,siparisAdeti:Int)
    func sepetiAzaltTıklandı(indexPath:IndexPath,siparisAdeti:Int)
}

class SepetHucre: UITableViewCell {

    

    @IBOutlet weak var imageViewSepet: UIImageView!
    @IBOutlet weak var labelSepetAdet: UILabel!
    @IBOutlet weak var labelSepetFiyat: UILabel!
    @IBOutlet weak var labelSepetAd: UILabel!
    
    var silAction: (() -> Void)?
    var hucreProtocol:HucreProtocol?
    var indexPath:IndexPath?
    var siparisAdeti:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    @IBAction func buttonSepetSil(_ sender: Any) {
        silAction?()
    }
    
    
    @IBAction func buttonSepetAdetAzalt(_ sender: Any) {
        if let indexPath = indexPath, let siparisAdeti = siparisAdeti {
            hucreProtocol?.sepetiAzaltTıklandı(indexPath: indexPath, siparisAdeti: siparisAdeti)
        }
    }

    @IBAction func buttonSepetArttır(_ sender: Any) {
        if let indexPath = indexPath, let siparisAdeti = siparisAdeti {
            hucreProtocol?.sepetiArtırTıklandı(indexPath: indexPath, siparisAdeti: siparisAdeti)
        }
    }

    
    
}
