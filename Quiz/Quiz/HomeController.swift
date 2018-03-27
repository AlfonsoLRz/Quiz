//
//  ViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 26/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: propiedades de la interfaz
    
    @IBOutlet weak var botonConfig: UIBarButtonItem!    // Botón derecho en la barra de navegación.
    
    // MARK: Otros atributos
    
    private let gestionPreguntas = GestionPreguntas()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cargamos el icono del botón derecho de la barra de navegación.
        botonConfig.image = UIImage(named: "ConfigBoton")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

