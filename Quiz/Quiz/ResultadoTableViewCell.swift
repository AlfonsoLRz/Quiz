//
//  ResultadoTableViewCell.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ResultadoTableViewCell: UITableViewCell {
    
    //MARK: Atributos relacions con la interfaz
    
    @IBOutlet weak var categoríaLabel: UILabel!
    @IBOutlet weak var posicionLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var puntuacionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
