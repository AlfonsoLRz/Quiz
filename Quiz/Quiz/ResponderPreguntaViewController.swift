//
//  ResponderPreguntaViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 07/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ResponderPreguntaViewController: UIViewController {
    
    //MARK: Atributos
    
    var partida : Partida?
    
    //MARK: Atributos relacionados con la interfaz
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var respuesta1: UIButton!
    @IBOutlet weak var respuesta2: UIButton!
    @IBOutlet weak var respuesta3: UIButton!
    @IBOutlet weak var respuesta4: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Comprobamos que tenemos una partida adecuada de donde ir sacando las respuestas...
        guard let _ = self.partida else {
            fatalError("Necesitamos una partida adecuada de donde poder obtener las preguntas.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
