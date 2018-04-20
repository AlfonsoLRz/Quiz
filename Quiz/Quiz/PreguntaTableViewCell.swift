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
    
    @IBOutlet weak var imagenPregunta: UIImageView!     // Imagen de la pregunta.
    @IBOutlet weak var preguntaLabel: UILabel!          // Título de la pregunta.
    @IBOutlet weak var categoriaLabel: UILabel!         // Categoría de la pregunta.
    
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
