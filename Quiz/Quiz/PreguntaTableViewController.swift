//
//  PreguntaTableViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 28/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import os.log
import UIKit

class PreguntaTableViewController: UITableViewController {
    
    //MARK: Atributos relacionados con la interfaz
    
    // Barra izquierda.
    @IBOutlet var botonVolver: UIBarButtonItem!
    @IBOutlet var botonHecho: UIBarButtonItem!
    
    // Barra derecha.
    @IBOutlet var botonAnadir: UIBarButtonItem!
    @IBOutlet var botonEditar: UIBarButtonItem!
    
    
    //MARK: Atributos
    
    var editable = false
    var gestionPreguntas : GestionPreguntas?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mostramos sólo los botones iniciales.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = botonVolver
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = botonEditar

        cargaPreguntas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gestionPreguntas = self.gestionPreguntas else {
            return 0
        }
        
        return gestionPreguntas.getNumPreguntas()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Las celdas de la tabla se reutilizan y deben ser identificadas.
        let identificadorCelda = "PreguntaTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identificadorCelda, for: indexPath) as? PreguntaTableViewCell else {
            fatalError("La celda de la cola no es una instancia de PreguntaTableViewCell.")
        }
        
        // Consigue la pregunta de la fila que necesita.
        guard let pregunta = gestionPreguntas!.getPregunta(index: indexPath.row) else {
            fatalError("La pregunta que buscamos excede los índices del vector de preguntas almacenado. ")
        }
        
        cell.preguntaLabel.text = pregunta.titulo
        cell.imagenPregunta.image = pregunta.imagen ?? UIImage(named: "DefaultImage")
        cell.categoriaLabel.text = pregunta.categoria

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editable
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier ?? "") {
        case "AñadirPregunta":
            os_log("Añadir una nueva comida.", log: OSLog.default, type: .debug)
        case "ModificarPregunta":
            guard let preguntaController = segue.destination as? PreguntaViewController else {
                fatalError("Destino inesperado: \(segue.destination)")
            }
            
            guard let celda = sender as? PreguntaTableViewCell else {
                fatalError("Fuente de evento inesperada: \(String(describing: sender))")
            }
            
            guard let indice = tableView.indexPath(for: celda) else {
                fatalError("La celda no está siendo mostrada en la tabla. ")
            }
            
            guard let gestionPreguntas = self.gestionPreguntas else {
                fatalError("No tenemos un gestionador de preguntas. ")
            }
            
            guard let preguntaSeleccionada = gestionPreguntas.getPregunta(index: indice.row) else {
                fatalError("La pregunta seleccionada excede los límites del conjunto de preguntas almacenado. ")
            }
            
            preguntaController.pregunta = preguntaSeleccionada
        default:
            fatalError("Identificador de navegación inesperado. ")
        }
    }
    
    @IBAction func editar(_ sender: UIBarButtonItem) {
        // Cambiamos el botón izquierdo: ahora sólo podemos guardar y no salir.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = botonHecho
        
        // Cambiamos el botón derecho...
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = botonAnadir
        
        // Ahora la tabla se puede editar.
        editable = true
    }
    
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        // Volvemos a al vista inicial, no podemos editar.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = botonVolver
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = botonEditar
        
        // Tenemos que darle al botón de editar de nuevo si queremos modificar la tabla.
        editable = false
    }
    
    @IBAction func volver(_ sender: UIBarButtonItem) {
        // Animación para hacer desaparecer esta ventana.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vuelveAListaDePreguntas(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PreguntaViewController, let pregunta = sourceViewController.pregunta {
            // Comprobamos que tenemos gestión de preguntas.
            guard let gestionPreguntas = self.gestionPreguntas else {
                fatalError("No tenemos un gestionador de preguntas. ")
            }
            
            // Añadimos una nueva pregunta.
            let nuevoIndice = IndexPath(row: gestionPreguntas.getNumPreguntas(), section: 0)
            gestionPreguntas.añadirPreguntas(preguntas: [pregunta])
            self.tableView.insertRows(at: [nuevoIndice], with: .automatic)
        }
    }

    
    //MARK: Métodos privados
    
    private func cargaPreguntas() {
        /*let photo1 = UIImage(named: "DefaultImage")
        let photo2 = UIImage(named: "DefaultImage")
        var mensaje = ""
        
        guard let pregunta1 = Pregunta(titulo: "Hola", imagen: photo1, categoria: "Prueba", respuestas: nil, mensaje: &mensaje) else {
            fatalError("")
        }
        
        guard let pregunta2 = Pregunta(titulo: "Prueba", imagen: photo2, categoria: "Prueba", respuestas: nil, mensaje: &mensaje) else {
            fatalError("")
        }
        
        guard let gestionPreguntas = self.gestionPreguntas else {
            fatalError("No tenemos un gestionador de preguntas. ")
        }
        
        gestionPreguntas.añadirPreguntas(preguntas: [pregunta1, pregunta2])*/
    }

}
