//
//  EsperaViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class EsperaViewController: UIViewController {
    
    //MARK: Atributos relacionados con la interfaz
    
    @IBOutlet weak var aciertosLabel: UILabel!              // Número de aciertos en este momento.
    @IBOutlet weak var puntuaciónLabel: UILabel!            // Puntuación momentánea (derivada de los aciertos).
    @IBOutlet weak var tiempoMedioLabel: UILabel!           // Tiempo medio de respuesta.
    
    //MARK: Atributos
    var partida : Partida?                                  // Características de la partida en desarrollo.
    
    
    /**
     
     Construcción de la pantalla de espera (carga).
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = self.partida else {
            fatalError("No hay información de la partida. No podemos continuar...")
        }
        
        // Una vez sabemos que tenemos los datos necesarios, actualizamos la interfaz.
        self.preparaVista()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK: Actions
    
    /**
 
     Evento que se activa al pulsar el botón de salir.
 
     */
    @IBAction func salir(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Salir de la partida", message: "¿Estás seguro de que quieres salir de la partida?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí", style: .destructive, handler: { action in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)    // Si pulsa 'Sí', quitamos la vista...
        }))
		alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Métodos privados
    
    /**
 
     Construye la información de la vista (labels): aciertos, puntuación, tiempo medio...
     
    */
    private func preparaVista() {
        self.aciertosLabel.text = "Aciertos: \(self.partida!.getAciertos())"
        self.puntuaciónLabel.text = "Puntuación: \(self.partida!.getPuntuación())"
        self.tiempoMedioLabel.text = "Tiempo medio de respuesta: \(self.partida!.getTiempoMedio()) s"
    }
}
