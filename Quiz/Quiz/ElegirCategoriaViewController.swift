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
    
    @IBOutlet weak var seleccionCategoria: UIPickerView!            // PickerView con todas las categorías que podemos elegir. Como mínimo aparecerá Todas.
    
    
    //MARK: Otras propiedades
    
    var clasificación : Clasificación?                              // Gestión de los resultados de las partidas, almacenados en la BD y futuros.
    var gestionPreguntas : GestionPreguntas?                        // Gestión de preguntas almacenadas y disponibles para jugar.
    
    
    
    /**
     
     Inicialización de las variables necesarias para el correcto funcionamiento de la vista. Se ejecuta antes de aparecer por primera vez.
     
     */
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

    /**
     
     Preparación para un segue.
     -ComenzarPartida: Se comienza un juego, teniendo que en cuenta que contendrá las preguntas de una categoría concreta.
     
     */
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
        } else {
            fatalError("Navegación desconocida en la vista de Elegir categoría.")
        }
    }
    
    /**
     
     Comprobación previa a un segue, donde habrá que confirmar si se debe ejecutar o no.
     
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ComenzarPartida" {
            // Se podrá jugar siempre y cuando haya al menos una pregunta.
            return self.gestionPreguntas!.getNumPreguntas() > 0
        } 
        
        return false
    }
    
    
    //MARK: Actions
    
    /**
     
     Método que se ejecuta al pulsar el botón de comenzar una partida.
     
     - parameters:
        - sender: Botón emisor del evento.
     
     */
    @IBAction func comenzarPartida(_ sender: UIButton) {
        if self.gestionPreguntas!.getNumPreguntas() == 0 {
            // Creamos la alerta con el mensaje de error.
            let alert = UIAlertController(title: "No podemos jugar", message: "Para poder jugar se necesita al menos una pregunta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
 
     Método que se ejecuta al presionar el botón de volver.
     
     */
    @IBAction func volver(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UIPickerViewDataSource
    
    /**
 
     Devuelve el número de componentes de los que se compondrá el pickerView.
     
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Sólo tenemos un componente que serán las categorias.
        return 1
    }
    
    /**
     
     Devuelve el número de categorías que tendremos. Nótese que nos pregunta por el número de filas en un componente (en nuestro caso sólo tendremos 1).
 
    */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.gestionPreguntas?.getNumCategorias())! + 1
    }
    
    /**
 
     Devuelve la categoría que se ubica en una fila concreta del pickerView.
     
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Todas"
        } else {
            return self.gestionPreguntas!.getCategoria(index: row - 1)
        }
    }
}
