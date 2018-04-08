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
    
    var clasificacion : Clasificación?
    private var resultadosFiltrados = [ResultadoPartida]()
    
    
    //MARK: Atributos relacionados con la interfaz
    private let searchController = UISearchController(searchResultsController: nil)

    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if estáFiltrando() {
            return self.resultadosFiltrados.count
        }
        
        return self.clasificacion!.getNumResultados()
    }

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
        cell.categoríaLabel.text = resultado!.getCategoría()
        cell.posicionLabel.text = String(indexPath.row + 1)
        cell.puntuacionLabel.text = String(resultado!.puntuación)
        cell.timestampLabel.text = resultado!.getFecha()
        
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

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Actualizamos la clasificación.
            if estáFiltrando() {
                if let index = self.clasificacion!.índiceDeResultado(resultado: self.resultadosFiltrados[indexPath.row]) {
                    self.clasificacion!.eliminaResultado(index: index)
                }
                
                self.resultadosFiltrados.remove(at: indexPath.row)
            } else {
                self.clasificacion!.eliminaResultado(index: indexPath.row)
            }
            
            // Guardamos en fichero los nuevos resultados.
            self.clasificacion!.guardaResultados()
            
            // Actualizamos la tabla.
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    //MARK: Soporte para la búsqueda.
    
    private func barraDeBúsquedaVacía() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func estáFiltrando() -> Bool {
        return self.searchController.isActive && !barraDeBúsquedaVacía()
    }
    
    private func filtraContenido(textoBúsqueda: String) {
        self.resultadosFiltrados = self.clasificacion!.filtrarPorCategoria(categoria: textoBúsqueda)
        tableView.reloadData()
    }
    
    
    //MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filtraContenido(textoBúsqueda: self.searchController.searchBar.text!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Action
    
    @IBAction func volver(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
