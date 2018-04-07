//
//  ResultadosViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ResultadosViewController: UIViewController {
    
    //MARK: Atributos relacionados con la interfaz
    
    @IBOutlet weak var cabeceraLabel: UILabel!
    @IBOutlet weak var descripciónLabel: UILabel!
    @IBOutlet weak var aciertosLabel: UILabel!
    @IBOutlet weak var puntuaciónLabel: UILabel!
    @IBOutlet weak var tiempoMedioLabel: UILabel!
    
    //MARK: Atributos
    
    // Constantes
    private let CABECERA_VICTORIA = "¡Enhorabuena!"
    private let CABECERA_DERROTA = "¡Vaya!"
    
    private let DESCRIPCIÓN_VICTORIA = "Has completado el test sin fallos"
    private let DESCRIPCIÓN_DERROTA = "Parece que has fallado esta pregunta"
    
    var clasificacion : Clasificación?
    var partida : Partida?
    var victoria : Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Comprobamos si tenemos los atributos necesarios.
        guard let _ = self.clasificacion else {
            fatalError("Necesitamos una clasificación adecuada para añadir los resultados de la partida actual.")
        }
        
        guard let _ = self.partida else {
            fatalError("Necesitamos los datos de la partida para mostrar las estadísticas.")
        }
        
        guard let _ = self.victoria else {
            fatalError("Necesitamos conocer si es una victoria o una derrota para mostrar los mensajes oportunos.")
        }
        
        // Labels dependientes del resultado de la partida.
        if self.victoria! {
            self.cabeceraLabel.text = CABECERA_VICTORIA
            self.descripciónLabel.text = DESCRIPCIÓN_VICTORIA
        } else {
            self.cabeceraLabel.text = CABECERA_DERROTA
            self.descripciónLabel.text = DESCRIPCIÓN_DERROTA
        }
        
        // Estadísticas.
        self.aciertosLabel.text = "Aciertos: \(self.partida!.getAciertos())"
        self.puntuaciónLabel.text = "Puntuación: \(self.partida!.getPuntuación())"
        self.tiempoMedioLabel.text = "Tiempo medio de respuesta: \(self.partida!.getTiempoMedio())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    

}
