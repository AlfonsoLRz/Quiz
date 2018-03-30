//
//  PreguntaTableViewCell.swift
//  Quiz
//
//  Created by AlfonsoLR on 28/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class PreguntaTableViewCell: UITableViewCell {
    
    //MARK: Atributos de la interfaz
    
    @IBOutlet weak var imagenPregunta: UIImageView!
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
