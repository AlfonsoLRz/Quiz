//
//  ViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 26/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: Atributos
    
    private let gestionPreguntas = GestionPreguntas()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        switch (segue.identifier ?? "") {
        case "GestionarPreguntas":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let gestionarPreguntasController = destinationNavigation?.topViewController as? PreguntaTableViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            gestionarPreguntasController.gestionPreguntas = self.gestionPreguntas
        default:
            fatalError("Identificador de navegación desconocido. ")
        }
    }
}

