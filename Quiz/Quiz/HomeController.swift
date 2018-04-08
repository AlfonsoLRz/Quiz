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
    
    private let clasificacion = Clasificación()
    private let gestionPreguntas = GestionPreguntas()
    var segueARealizar : String?
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let segue = self.segueARealizar {
            self.performSegue(withIdentifier: segue, sender: nil)
        }
        self.segueARealizar = nil
    }
    
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
        case "SeleccionarCategoría":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let seleccionarCategoríaController = destinationNavigation?.topViewController as? ElegirCategoriaViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            seleccionarCategoríaController.clasificación = self.clasificacion
            seleccionarCategoríaController.gestionPreguntas = self.gestionPreguntas
        case "MostrarClasificación":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let mostrarClasificación = destinationNavigation?.topViewController as? ClasificaciónTableViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            mostrarClasificación.clasificacion = self.clasificacion
        default:
            fatalError("Identificador de navegación desconocido. ")
        }
    }
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        // Idle
    }
}

