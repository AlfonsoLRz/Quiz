//
//  GestionarPreguntasViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 29/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class GestionarPreguntasViewController: UINavigationController {
    
    //MARK: Atributos
    
    var gestionPreguntas : GestionPreguntas?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Hola")
        guard let tablaPreguntasController = segue.destination as? PreguntaTableViewController else {
            fatalError("Destino de segue inesperado. ")
        }
        
        print("Hola \(self.gestionPreguntas?.getNumPreguntas())")
        
        tablaPreguntasController.gestionPreguntas = self.gestionPreguntas
    }

}
