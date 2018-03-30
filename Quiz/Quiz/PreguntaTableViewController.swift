//
//  PreguntaTableViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 28/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import os.log
import UIKit

class PreguntaTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
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
    
    // Proceso de búsqueda.
    var preguntasFiltradas = [Pregunta]()
    let searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comprobamos que tenemos un gestor de preguntas.
        guard let _ = self.gestionPreguntas else {
            fatalError("La vista PreguntaTableViewController no presenta un gestor de preguntas adecuado.")
        }
        
        // Mostramos sólo los botones iniciales.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = botonVolver
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = botonEditar
        
        // Barra de búsqueda.
        self.searchController.searchResultsUpdater = self   // ¿Quién recibe información de actualizaciones en la barra de búsqueda?
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false  // Evitar esconder la barra de navegación al buscar.
        self.searchController.searchBar.placeholder = "Busca preguntas"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false     // Siempre aparece la barra de búsqueda.
        self.definesPresentationContext = true      // Evitar que siga apareciendo incluso al cambiar a otras vistas.
        
        // Campos de búsqueda.
        self.searchController.searchBar.scopeButtonTitles = ["Título", "Categoría"]
        self.searchController.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if estaFiltrando() {
            return self.preguntasFiltradas.count
        } else {
            return self.gestionPreguntas!.getNumPreguntas()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Las celdas de la tabla se reutilizan y deben ser identificadas.
        let identificadorCelda = "PreguntaTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identificadorCelda, for: indexPath) as? PreguntaTableViewCell else {
            fatalError("La celda de la cola no es una instancia de PreguntaTableViewCell.")
        }
        
        // Consigue la pregunta de la fila que necesita.
        let pregunta : Pregunta
        if estaFiltrando() {
            guard indexPath.row < preguntasFiltradas.count else {
                fatalError("Índice fuera de los límites del vector preguntasFiltradas: \(indexPath.row)")
            }
            
            pregunta = self.preguntasFiltradas[indexPath.row]
        } else {
            guard indexPath.row < self.gestionPreguntas!.getNumPreguntas() else {
                fatalError("Índice fuera de los límites del vector preguntas.")
            }
            
            pregunta = self.gestionPreguntas!.getPregunta(index: indexPath.row)!
        }
        
        cell.preguntaLabel.text = pregunta.titulo
        cell.imagenPregunta.image = pregunta.imagen ?? UIImage(named: "DefaultImage")
        cell.categoriaLabel.text = pregunta.categoria

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editable
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if estaFiltrando() {
                // Desconocemos el índice en el vector original, sólo sabemos el índice en preguntasFiltradas.
                if let index = self.gestionPreguntas!.indiceDePregunta(pregunta: self.preguntasFiltradas[indexPath.row]) {
                    self.gestionPreguntas!.eliminarPregunta(index: index)
                }
                
                self.preguntasFiltradas.remove(at: indexPath.row)
            } else {
                self.gestionPreguntas!.eliminarPregunta(index: indexPath.row)
            }
            
            self.gestionPreguntas!.guardaPreguntas()
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    // MARK: Navigation

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
            
            let preguntaSeleccionada : Pregunta
            if estaFiltrando() {
                preguntaSeleccionada = self.preguntasFiltradas[indice.row]
            } else {
                preguntaSeleccionada = self.gestionPreguntas!.getPregunta(index: indice.row)!
            }
            
            preguntaController.pregunta = preguntaSeleccionada
        default:
            fatalError("Identificador de navegación inesperado. ")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return editable
    }
    
    
    //MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        if scope == "Título" {
            self.preguntasFiltradas = (self.gestionPreguntas?.filtrarPorNombre(nombre: searchBar.text!))!
        } else if scope == "Categoría" {
            self.preguntasFiltradas = (self.gestionPreguntas?.filtrarPorCategoria(categoria: searchBar.text!))!
        } else {
            fatalError("Categoría de búsqueda desconocida: \(scope)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: Actions
    
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
            
            // Actualización de comida.
            if let indiceSeleccionado = tableView.indexPathForSelectedRow {
                var eliminaFila = false
                
                if estaFiltrando() {
                    if let index = self.gestionPreguntas!.indiceDePregunta(pregunta: self.preguntasFiltradas[indiceSeleccionado.row]) {
                        self.gestionPreguntas!.modificarPregunta(pregunta: pregunta, index: index)
                        
                        if !self.gestionPreguntas!.preguntaEncajaEnBusqueda(pregunta: pregunta, busqueda: searchController.searchBar.text!, campo: searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]) {
                            self.preguntasFiltradas.remove(at: indiceSeleccionado.row)
                            eliminaFila = true
                        }
                    }
                } else {
                    self.gestionPreguntas!.modificarPregunta(pregunta: pregunta, index: indiceSeleccionado.row)
                }
                
                if !eliminaFila {
                    tableView.reloadRows(at: [indiceSeleccionado], with: .none)
                }
                
            // Añadimos una nueva comida.
            } else {
                var nuevoIndice : IndexPath?
                
                if estaFiltrando() && self.gestionPreguntas!.preguntaEncajaEnBusqueda(pregunta: pregunta, busqueda: searchController.searchBar.text!, campo: searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]) {
                    nuevoIndice = IndexPath(row: preguntasFiltradas.count, section: 0)
                    preguntasFiltradas.append(pregunta)
                } else if !estaFiltrando() {
                    nuevoIndice = IndexPath(row: self.gestionPreguntas!.getNumPreguntas(), section: 0)
                }
                
                self.gestionPreguntas!.añadirPreguntas(preguntas: [pregunta])
                
                if let indice = nuevoIndice {
                    tableView.insertRows(at: [indice], with: .automatic)
                }
            }
            
            // Guardamos cambios en fichero.
            self.gestionPreguntas!.guardaPreguntas()
        }
    }

    
    //MARK: Métodos privados
    
    private func barraDeBusquedaEstaVacia() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func estaFiltrando() -> Bool {
        return self.searchController.isActive && !self.barraDeBusquedaEstaVacia()
    }

}
