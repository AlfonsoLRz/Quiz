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
    
    @IBOutlet weak var categoríaLabel: UILabel!             // Categoría de la partida.
    @IBOutlet weak var posicionLabel: UILabel!              // Posición de este resultado dentro de la clasificación.
    @IBOutlet weak var imagen: UIImageView!                 // Imagen del resultado. Si está entre los tres primeros tendrá una corona.
    @IBOutlet weak var puntuacionLabel: UILabel!            // Puntuación obtenida en la partida.
    @IBOutlet weak var timestampLabel: UILabel!             // Fecha en la que se realizó la partida.
    
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
