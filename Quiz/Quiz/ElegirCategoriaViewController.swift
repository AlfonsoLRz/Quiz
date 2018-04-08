//
//  ElegirCategoriaViewController.swift
//  Quiz
//
//  Created by Macosx on 4/4/18.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ElegirCategoriaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Atributos relacionados con la UI
    
    @IBOutlet weak var seleccionCategoria: UIPickerView!
    
    //MARK: Otras propiedades
    
    var clasificación : Clasificación?
    var gestionPreguntas : GestionPreguntas?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comprobamos que tenemos una clasificación no nula; la necesitaremos para la pantalla final de una partida.
        guard let _ = self.clasificación else {
            fatalError("La vista de selección de categorías necesita una clasificación.")
        }
        
        // Comprobamos que tenemos un gestor de preguntas adecuado.
        guard let _ = self.gestionPreguntas else {
            fatalError("La vista de selección de categorías necesita un gestor de preguntas adecuado.")
        }
        
        // Seleccionamos nuestra vista como la que controla la selección de categorías.
        self.seleccionCategoria.delegate = self
        self.seleccionCategoria.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ComenzarPartida" {
            let destinationNavigation = segue.destination as? UINavigationController
            guard let responderPreguntaController = destinationNavigation?.topViewController as? ResponderPreguntaViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            // Obtenemos la categoría seleccionada.
            let index = self.seleccionCategoria.selectedRow(inComponent: 0)
            var preguntas : [Pregunta]
            var categoria = "Todas"
            if index >= 1 {
                categoria = self.gestionPreguntas!.getCategoria(index: index - 1)
                preguntas = self.gestionPreguntas!.filtrarPorCategoria(categoria: categoria)
            } else {
                preguntas = self.gestionPreguntas!.getTodas()
            }
            
            responderPreguntaController.clasificación = self.clasificación
            responderPreguntaController.partida = Partida(categoría: categoria, preguntas: preguntas)
        } else if segue.identifier != "NoPreguntasPopOver" {
            fatalError("Navegación desconocida en la vista de Elegir categoría.")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ComenzarPartida" {
            return self.gestionPreguntas!.getNumPreguntas() > 0
        } 
        
        return false
    }
    
    
    //MARK: Actions
    
    @IBAction func comenzarPartida(_ sender: UIButton) {
        if self.gestionPreguntas!.getNumPreguntas() == 0 {
            self.performSegue(withIdentifier: "NoPreguntasPopOver", sender: sender)
        }
    }
    
    @IBAction func volver(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Sólo tenemos un componente que serán las categorias.
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.gestionPreguntas?.getNumCategorias())! + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Todas"
        } else {
            return self.gestionPreguntas!.getCategoria(index: row - 1)
        }
    }
}
