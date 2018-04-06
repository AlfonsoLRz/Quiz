//
//  ClasificaciónTableViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ClasificaciónTableViewController: UITableViewController {
    
    //MARK: Atributos
    
    var clasificacion : Clasificación?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Comprobamos si tenemos una clasificación de donde podemos mostrar los resultados obtenidos.
        guard let _ = self.clasificacion else {
            fatalError("La vista de Clasificación necesita los resultados obtenidos.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clasificacion!.getNumResultados()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identificadorCelda = "ResultadoTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identificadorCelda, for: indexPath) as? ResultadoTableViewCell else {
            fatalError("La celda obtenida no es una instancia de ResultadoTableViewCell")
        }

        // Obtenemos el resultado que debemos mostrar.
        let resultado = self.clasificacion!.getResultado(index: indexPath.row)
        
        // Tenemos que modificar también la celda con el resultado obtenido.
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
        return false
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
