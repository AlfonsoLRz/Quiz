//
//  ClasificaciónTableViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ClasificaciónTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Atributos

    var clasificacion : Clasificación?                          // Clase que gestiona todos los resultados.
    private var resultadosFiltrados = [ResultadoPartida]()      // Resultados de una búsqueda concreta.


    //MARK: Atributos relacionados con la interfaz

    private let searchController = UISearchController(searchResultsController: nil)     // Controlador de la barra de búsqueda.


    /**

     Acciones a llevar a cabo cuando se cargue la vista. Se inicializa la clasificación, la barra de búsqueda...

    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Comprobamos si tenemos una clasificación de donde podemos mostrar los resultados obtenidos.
        guard let _ = self.clasificacion else {
            fatalError("La vista de Clasificación necesita los resultados obtenidos.")
        }

        // Configuramos la barra de búsqueda.
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busca resultados por categoría"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: Table view data source

    /**

     Elimina un resultado de la base de datos, recibiendo el índice de la fila seleccionada dentro de la tabla
     y que se quiere borrar.

     */
    func eliminaResultado(tableView: UITableView, indexPath: IndexPath) {
        // Actualizamos la clasificación.
        if estáFiltrando() {
            if let index = self.clasificacion!.índiceDeResultado(resultado: self.resultadosFiltrados[indexPath.row]) {
                self.clasificacion!.eliminaResultado(index: index)
            }

            self.resultadosFiltrados.remove(at: indexPath.row)
        } else {
            self.clasificacion!.eliminaResultado(index: indexPath.row)
        }

        // Actualizamos la tabla.
        tableView.reloadData()
    }

    /**

     Número de secciones en la tabla. Sólo tendremos una, que serán los resultados.

    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**

     Devuelve el número de elementos en la sección especificada. Nótese que al devolver sólo una sección, sólo nos preguntará
     el número de resultados que debe mostrar. Esto dependerá también de si hay una búsqueda activa, o no.

    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if estáFiltrando() {
            return self.resultadosFiltrados.count
        }

        return self.clasificacion!.getNumResultados()
    }

    /**

     Devuelve una celda a posicionar en la tabla. Nótese que habrá que configurar la celda para que tenga la imagen, posición... apropiados.

    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identificadorCelda = "ResultadoTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identificadorCelda, for: indexPath) as? ResultadoTableViewCell else {
            fatalError("La celda obtenida no es una instancia de ResultadoTableViewCell")
        }

        // Obtenemos el resultado que debemos mostrar.
        var resultado : ResultadoPartida?
        if estáFiltrando() {
            resultado = self.resultadosFiltrados[indexPath.row]
        } else {
            resultado = self.clasificacion!.getResultado(index: indexPath.row)
        }

        // Tenemos que modificar también la celda con el resultado obtenido.
        cell.categoríaLabel.text = resultado!.categoría
        cell.posicionLabel.text = String(indexPath.row + 1)
        cell.puntuacionLabel.text = String(resultado!.puntuación)
        cell.timestampLabel.text = resultado!.fecha

        // Asignaremos imagen en función de si está entre los primeros o no...
        var image : UIImage?
        switch indexPath.row {
        case 0:
            image = UIImage(named: "Oro")
        case 1:
            image = UIImage(named: "Plata")
        case 2:
            image = UIImage(named: "Bronce")
        default:
            image = nil
        }
        cell.imagen.image = image

        return cell
    }

    /**

     Siempre es editable la tabla, luego siempre devolveremos verdadero.

    */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /**

     Edición de la tabla. Sólo utilizaremos la función de borrado.
     Se mostrará un mensaje pidiendo al usuario que confirme que quiere borrar el resultado.

    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Eliminar resultado", message: "¿Estás seguro de que quieres eliminar este resultado?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sí", style: .destructive, handler: { action in
                self.eliminaResultado(tableView: tableView, indexPath: indexPath)
            }))
			alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


    //MARK: Soporte para la búsqueda.

    /**

     Devuelve un booleano en función de si la barra de búsqueda está vacía.

    */
    private func barraDeBúsquedaVacía() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }

    /**

     Devuelve un booleano en función de si hay una búsqueda activa o no.

    */
    private func estáFiltrando() -> Bool {
        return self.searchController.isActive && !barraDeBúsquedaVacía()
    }

    /**

     Actualiza el contenido del vector de resultados filtrados, es decir, efectúa una búsqueda.

    */
    private func filtraContenido(textoBúsqueda: String) {
        self.resultadosFiltrados = self.clasificacion!.filtrarPorCategoria(categoria: textoBúsqueda)
        tableView.reloadData()
    }


    //MARK: UISearchResultsUpdating

    /**

     Aviso de actualización (cambios) en la barra de búsqueda.

    */
    func updateSearchResults(for searchController: UISearchController) {
        filtraContenido(textoBúsqueda: self.searchController.searchBar.text!)
    }


    //MARK: Actions

    /**

     Presión de botón Volver. Se vuelve a la vista anterior, sin importar desde dónde se llame.

    */
    @IBAction func volver(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
