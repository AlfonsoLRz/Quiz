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
    
    private let clasificacion = Clasificación()             // Gestor de resultados de partidas.
    private let gestionPreguntas = GestionPreguntas()       // Gestor de preguntas existentes en la base de datos.
    var segueARealizar : String?                            // Segue que debemos realizar cuando la vista aparezca. Nótese que al comienzo de la aplicación no tendrá que hacer ningún segue, pero sí en otras situaciones.
    
    
    /**
     
     Método que se ejecuta cuando la vista ya ha aparecido. Ejecutará el segue contenido en segueARealizar, si lo hay.
 
     */
    override func viewDidAppear(_ animated: Bool) {
        if let segue = self.segueARealizar {
            self.segueARealizar = nil
            self.performSegue(withIdentifier: segue, sender: nil)
        }
    }
    
    /**
     
     Método que se ejecuta una vez la vista se ha cargado. Todas las variables están ya inicializadas, luego no hará inicializar alguna.
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    
    /**
     
     Preparación para una navegación concreta hacia alguna vista.
     
     */
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
    
    /**
     
     Será el método de vuelta atrás que ejecuten vistas posteriores. Dado que sólo utilizan el atributo segueARealizar, no hace falta realizar
     acción alguna en este método.
     
     */
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        // Idle
    }
}

