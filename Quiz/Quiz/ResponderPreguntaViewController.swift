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
    
    var clasificación : Clasificación?
    var partida : Partida?
    var preguntaActual : Pregunta?
    var tiempoRestante = 30
    var timer : Timer?
    
    //MARK: Atributos relacionados con la interfaz
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var respuesta1: UIButton!
    @IBOutlet weak var respuesta2: UIButton!
    @IBOutlet weak var respuesta3: UIButton!
    @IBOutlet weak var respuesta4: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comprobamos que tenemos una clasificación adecuada para poder actualizar al final de la partida.
        guard let _ = self.clasificación else {
            fatalError("Necesitamos una clasificación adecuada para poder actualizarla al final de la partida.")
        }

        // Comprobamos que tenemos una partida adecuada de donde ir sacando las respuestas...
        guard let _ = self.partida else {
            fatalError("Necesitamos una partida adecuada de donde poder obtener las preguntas.")
        }
        
        // Primera pregunta.
        self.cambiaPregunta()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Métodos públicos
    
    @objc func decrementaTiempo() {
        self.tiempoRestante -= 1
        
        if self.tiempoRestante == -1 {
            self.timerLabel.text = "--"
            self.timer!.invalidate()
            
            self.partida!.sumarTiempo(tiempo: 30)
            self.performSegue(withIdentifier: "MostrarResultado", sender: nil)
        } else {
            // Si todavía no es el final mostramos el tiempo restante.
            self.timerLabel.text = String(self.tiempoRestante)
        }
    }
    

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "MostrarSiguientePregunta":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let esperaPreguntaController = destinationNavigation?.topViewController as? EsperaViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            esperaPreguntaController.partida = self.partida
        case "MostrarResultado":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let mostrarResultadoController = destinationNavigation?.topViewController as? ResultadosViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }
            
            mostrarResultadoController.clasificacion = self.clasificación
            mostrarResultadoController.partida = self.partida
            mostrarResultadoController.victoria = self.partida!.getAciertos() == self.partida!.getTotalPreguntas()
        default:
            fatalError("Identificador de navegación desconocido. ")
        }
    }
    
    @IBAction func unwindToResponderPregunta(sender: UIStoryboardSegue) {
        // Lo único que tendremos que hacer es sacar la siguiente pregunta y actualizar timers.
        self.cambiaPregunta()
        
        // Actualizamos la interfaz.
        self.preparaVista(pregunta: self.preguntaActual!)
    }
    
    
    //MARK: Acción de botones
    
    @IBAction func presionarRespuesta1(_ sender: UIButton) {
        self.respuestaElegida(button: sender)
    }
    
    @IBAction func presionarRespuesta2(_ sender: UIButton) {
        self.respuestaElegida(button: sender)
    }
    
    @IBAction func presionarRespuesta3(_ sender: UIButton) {
        self.respuestaElegida(button: sender)
    }
    
    @IBAction func presionarRespuesta4(_ sender: UIButton) {
        self.respuestaElegida(button: sender)
    }
    
    @IBAction func salir(_ sender: UIBarButtonItem) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func respuestaElegida(button: UIButton) {
        // Actualizamos la partida siempre y cuando el objeto emisor exista. Nos sirve para actualizar aciertos, tiempo...
        self.actualizaPartida(sender: button)
        
        // Situación de fallo.
        if self.partida!.getAciertos() < self.partida!.getPreguntasUtilizadas() {
            self.performSegue(withIdentifier: "MostrarResultado", sender: button)
            
            // Situación de fin de partida con todas acertadas.
        } else if self.partida!.getPreguntasUtilizadas() == self.partida!.getTotalPreguntas() {
            self.performSegue(withIdentifier: "MostrarResultado", sender: button)
            
            // Cualquier otro caso, que debería ser una pregunta acertada.
        } else {
            self.performSegue(withIdentifier: "MostrarSiguientePregunta", sender: button)
        }
    }
    
    
    //MARK: Métodos privados
    
    private func actualizaPartida(sender: UIButton?) {
        // Primero actualizaremos los aciertos; nos servirá para decidir si mostrar resultado final o la pantalla de siguiente pregunta.
        let respuestas = self.preguntaActual!.respuestas
        
        // Comprobamos que el evento viene de uno de los cuatro botones.
        if let button = sender {
            switch button {
            case respuesta1:
                if respuesta1.titleLabel!.text == respuestas[0] {
                    self.partida!.sumarAcierto()
                }
            case respuesta2:
                if respuesta2.titleLabel!.text == respuestas[0] {
                    self.partida!.sumarAcierto()
                }
            case respuesta3:
                if respuesta3.titleLabel!.text == respuestas[0] {
                    self.partida!.sumarAcierto()
                }
            case respuesta4:
                if respuesta4.titleLabel!.text == respuestas[0] {
                    self.partida!.sumarAcierto()
                }
            default:
                fatalError("Botón origen de evento desconocido.")
            }
        }
        
        // Añadimos el tiempo usado.
        self.partida!.sumarTiempo(tiempo: 30 - self.tiempoRestante)
    }
    
    private func cambiaPregunta() {
        self.preguntaActual = partida!.getSiguientePregunta()!
        self.preparaVista(pregunta: self.preguntaActual!)
        self.tiempoRestante = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResponderPreguntaViewController.decrementaTiempo), userInfo: nil, repeats: true)
    }
    
    private func preparaVista(pregunta: Pregunta) {
        self.title = "Pregunta \(self.partida!.getPreguntasUtilizadas()) de \(self.partida!.getTotalPreguntas())"
        self.tituloLabel.text = pregunta.titulo
        self.imagen.image = pregunta.imagen ?? UIImage(named: "DefaultImage")
        
        // Barajamos un poco las respuestas...
        let respuestas = pregunta.respuestas
        var ordenRespuestas = [Int]()
        
        // Rellenamos el vector con el orden de las respuestas.
        for i in 0..<respuestas.count {
            ordenRespuestas.append(i)
        }
        
        for _ in 0...2 {
            for i in 0..<respuestas.count {
                let index = Int(arc4random_uniform(UInt32(respuestas.count)))
                ordenRespuestas.swapAt(i, index)
            }
        }

        self.respuesta1.setTitle(respuestas[ordenRespuestas[0]], for: .normal)
        self.respuesta2.setTitle(respuestas[ordenRespuestas[1]], for: .normal)
        self.respuesta3.setTitle(respuestas[ordenRespuestas[2]], for: .normal)
        self.respuesta4.setTitle(respuestas[ordenRespuestas[3]], for: .normal)
        
        // Tiempo restante.
        self.timerLabel.text = String(self.tiempoRestante)
    }
}
