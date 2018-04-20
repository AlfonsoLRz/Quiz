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
    @IBOutlet var botonVolver: UIBarButtonItem!         // Primer botón: volver hacia Home.
    @IBOutlet var botonHecho: UIBarButtonItem!          // Segundo botón: confirmar cambios y volver al primer botón.
    
    // Barra derecha.
    @IBOutlet var botonAnadir: UIBarButtonItem!         // Segundo botón: añadir una pregunta.
    @IBOutlet var botonEditar: UIBarButtonItem!         // Primer botón: pasamos a editar las preguntas.
    
    
    //MARK: Atributos
    
    var editable = false                                // ¿Se pueden editar las filas de la tabla en este momento?
    var gestionPreguntas : GestionPreguntas?            // Gestor de preguntas de la base de datos.
    
    // Proceso de búsqueda.
    var preguntasFiltradas = [Pregunta]()                                       // Subconjunto de preguntas resultado de una búsqueda.
    let searchController = UISearchController(searchResultsController: nil)     // Controlador de la búsqueda.
    

    /**
 
     Método que se llama una vez se cargue la vista. Se inicializan todas las variables, y se configura la barra de navegación, de tal forma que los botones
     iniciales son los de Volver y Editar.
     
     */
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
        self.searchController.obscuresBackgroundDuringPresentation = false  // Evitar esconder la barra de navegación al buscar.
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

    /**
 
     Número de secciones de nuesta tabla: sólo una, de preguntas.
     
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
 
     Número de preguntas en nuestra sección. En función de si hay una búsqueda activa o no, este dato se cogerá de una fuente u otra.
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if estaFiltrando() {
            return self.preguntasFiltradas.count
        } else {
            return self.gestionPreguntas!.getNumPreguntas()
        }
    }

    /**
 
     Configura el contenido de una celda, añadiendo la imagen correcta, así como el título y la categoría de la misma.
 
     */
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

    /**
 
     ¿Se pueden editar las filas de la tabla? Dependerá de si el botón de la barra a la derecha es Editar o Añadir.
     
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editable
    }

    /**
 
     Modificación de la base de datos, sólo accesible cuando editable es verdadero. Sólo incluimos el borrado.
     En función de si hay una búsqueda activa o no, el proceso será más o menos complejo.
 
     */
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
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // MARK: Navigation

    /**
 
     Prepara la vista para llevar a cabo un segue hacia otra vista.
 
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier ?? "") {
        case "AñadirPregunta":
            os_log("Añadir una nueva pregunta.", log: OSLog.default, type: .debug)
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
    
    /**
     
     ¿Se debe ejecutar un segue hacia otra vista? También depende de si la tabla es editable o no. A tener en cuenta que los cambios de botones en esta vista
     no se producen por cambio de vista, sino por cambios en la interfaz de la misma.
 
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return editable
    }
    
    
    //MARK: UISearchResultsUpdating
    
    /**
 
     Método que se ejecutará al producirse cambios en la barra de búsqueda.
 
     */
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        // La búsqueda dependerá del campo: título o categoría.
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
    
    /**
     
     Método que se ejecutará al pulsar el botón de editar las preguntas.
 
     */
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
    
    /**
 
     Método que se ejecuta al pulsar el botón de guardar.
     
     */
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        // Volvemos a al vista inicial, no podemos editar.
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = botonVolver
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = botonEditar
        
        // Tenemos que darle al botón de editar de nuevo si queremos modificar la tabla.
        editable = false
    }
    
    /**
     
     Evento que se produce cuando se pulsa el botón de volver hacia Home.
 
     */
    @IBAction func volver(_ sender: UIBarButtonItem) {
        // Animación para hacer desaparecer esta ventana.
        dismiss(animated: true, completion: nil)
    }
    
    /**
 
     Método para volver desde cualquier vista hacia esta vista (Unwind).
 
     */
    @IBAction func vuelveAListaDePreguntas(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PreguntaViewController, let pregunta = sourceViewController.pregunta {
            
            // Actualización de comida.
            if let indiceSeleccionado = tableView.indexPathForSelectedRow {
                var eliminaFila = false
                
                if estaFiltrando() {
                    if let index = self.gestionPreguntas!.indiceDePregunta(pregunta: self.preguntasFiltradas[indiceSeleccionado.row]) {
                        self.gestionPreguntas!.modificarPregunta(pregunta: pregunta, index: index)
                        
                        // Es posible que la nueva pregunta, al actualizarse, ya no coincida con la búsqueda que existía, siempre y cuando hubiera una activa.
                        if !self.gestionPreguntas!.preguntaEncajaEnBusqueda(pregunta: pregunta, busqueda: searchController.searchBar.text!, campo: searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]) {
                            self.preguntasFiltradas.remove(at: indiceSeleccionado.row)
                            eliminaFila = true
                        }
                    }
                } else {
                    self.gestionPreguntas!.modificarPregunta(pregunta: pregunta, index: indiceSeleccionado.row)
                }
                
                // Si se elimina fila tras actualización, no hace falta recargarla.
                if !eliminaFila {
                    tableView.reloadRows(at: [indiceSeleccionado], with: .none)
                }
                
            // Añadimos una nueva comida.
            } else {
                let nuevoIndice = IndexPath(row: self.gestionPreguntas!.getNumPreguntas(), section: 0)
                
                // Se añade a nuestra fuente de preguntas y se inserta en la tabla físicamente.
                self.gestionPreguntas!.añadirPreguntas(preguntas: [pregunta])
                tableView.insertRows(at: [nuevoIndice], with: .automatic)
            }
        }
    }

    
    //MARK: Métodos privados
    
    /**
 
     Devuelve un booleano en función de si hay texto o no en la barra de búsqueda.
 
     */
    private func barraDeBusquedaEstaVacia() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    /**
 
     Devuelve un booleano en función de si hay una búsqueda activa o no. También depende de que la barra de búsqueda esté vacía.
 
     */
    private func estaFiltrando() -> Bool {
        return self.searchController.isActive && !self.barraDeBusquedaEstaVacia()
    }

}
