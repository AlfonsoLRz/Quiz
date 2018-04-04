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
    var gestionPreguntas : GestionPreguntas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Sólo tenemos un componente que serán las categorias.
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.gestionPreguntas?.getNumCategorias())!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.gestionPreguntas!.getCategoria(index: row)
    }
}
