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
    
    @IBOutlet weak var aciertosLabel: UILabel!
    @IBOutlet weak var puntuaciónLabel: UILabel!
    @IBOutlet weak var tiempoMedioLabel: UILabel!
    
    //MARK: Atributos
    var partida : Partida?
    
    
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
    

    /*
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: Actions
    
    @IBAction func salir(_ sender: UIBarButtonItem) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Métodos privados
    
    private func preparaVista() {
        self.aciertosLabel.text = "Aciertos: \(self.partida!.getAciertos())"
        self.puntuaciónLabel.text = "Puntuación: \(self.partida!.getPuntuación())"
        self.tiempoMedioLabel.text = "Tiempo medio de respuesta: \(self.partida!.getTiempoMedio()) s"
    }
}
