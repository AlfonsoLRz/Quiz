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

    var clasificación : Clasificación?                              // Gestor de resultados de partidas.
    var partida : Partida?                                          // Partida en curso, con información como aciertos, tiempo medio de respuesta...
    var preguntaActual : Pregunta?                                  // Pregunta a la que corresponde la actual vista.
    var tiempoRestante = 30                                         // Tiempo del que dispone el usuario como máximo para responder la pregunta.
    var timer : Timer?                                              // Timer que nos avisará cada segundo y nos ayudará con la cuenta atrás.

    // Colores de fondo posibles
    let colorFondo = [                                              // Colores que puede tener la vista.
        UIColor(red: 255, green: 0, blue: 0, alpha: 0.1),
        UIColor(red: 0, green: 255, blue: 0, alpha: 0.4),
        UIColor(red: 0, green: 0, blue: 255, alpha: 0.3),
        UIColor(red: 255, green: 255, blue: 0, alpha: 0.4),
        UIColor(red: 255, green: 0, blue: 255, alpha: 0.3),
        UIColor(red: 0, green: 255, blue: 255, alpha: 0.5),
        UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    ]

    //MARK: Atributos relacionados con la interfaz

    @IBOutlet weak var fondoView: UIView!                   // Fondo de la vista. Lo guardaremos para alterar su color.
    @IBOutlet weak var tituloLabel: UILabel!                // Título de la pregunta.
    @IBOutlet weak var imagen: UIImageView!                 // Imagen de la pregunta.
    @IBOutlet weak var respuesta1: UIButton!                // Respuestas...
    @IBOutlet weak var respuesta2: UIButton!
    @IBOutlet weak var respuesta3: UIButton!
    @IBOutlet weak var respuesta4: UIButton!
    @IBOutlet weak var timerLabel: UILabel!                 // Label con los segundos que quedan para poder responder.


    /**

     Método que se ejecuta al cargarse la vista. Comprueba que dispone de las variables necesarias para poder extraer y actualizar información.

     */
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

        // Centramos texto en las respuestas.
        self.respuesta1.titleLabel?.textAlignment = NSTextAlignment.center
        self.respuesta2.titleLabel?.textAlignment = NSTextAlignment.center
        self.respuesta3.titleLabel?.textAlignment = NSTextAlignment.center
        self.respuesta4.titleLabel?.textAlignment = NSTextAlignment.center

        // Primera pregunta.
        self.cambiaPregunta()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Métodos públicos

    /**

     El timer nos avisa de que ha pasado un segundo más, se decrementa el tiempo y se actualiza el label.

     */
    @objc func decrementaTiempo() {
        self.tiempoRestante -= 1

        if self.tiempoRestante == -1 {
            self.timerLabel.text = "--"
            self.timer!.invalidate()        // Se para el timer.

            self.partida!.sumarTiempo(tiempo: 30)
            self.performSegue(withIdentifier: "MostrarResultado", sender: nil)
        } else {
            // Si todavía no es el final mostramos el tiempo restante.
            self.timerLabel.text = String(self.tiempoRestante)
        }
    }


    // MARK: Navigation

    /**

     Preparación previa para los segues hacia otras vistas.

     */
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

    /**

     Segue unwind para volver hacia esta vista. Se ejecutará desde la vista de Espera.

    */
    @IBAction func unwindToResponderPregunta(sender: UIStoryboardSegue) {
        // Lo único que tendremos que hacer es sacar la siguiente pregunta y actualizar timers.
        self.cambiaPregunta()
    }


    //MARK: Acción de botones

    /**

     Se ha elegido una respuesta. Se para el timer y se comprueba si se ha elegido la correcta.

     */
    @IBAction func presionarRespuesta1(_ sender: UIButton) {
        self.timer?.invalidate()
        self.respuestaElegida(button: sender)
    }

    /**

     Se ha elegido una respuesta. Se para el timer y se comprueba si se ha elegido la correcta.

     */
    @IBAction func presionarRespuesta2(_ sender: UIButton) {
        self.timer?.invalidate()
        self.respuestaElegida(button: sender)
    }

    /**

     Se ha elegido una respuesta. Se para el timer y se comprueba si se ha elegido la correcta.

     */
    @IBAction func presionarRespuesta3(_ sender: UIButton) {
        self.timer?.invalidate()
        self.respuestaElegida(button: sender)
    }

    /**

     Se ha elegido una respuesta. Se para el timer y se comprueba si se ha elegido la correcta.

     */
    @IBAction func presionarRespuesta4(_ sender: UIButton) {
        self.timer?.invalidate()
        self.respuestaElegida(button: sender)
    }

    /**

     Evento que se activa cuando el usuario pulsa el botón de salir.
     Se presenta un botón para asegurarnos de que realmente quiere salir.

     */
    @IBAction func salir(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Salir de la partida", message: "¿Estás seguro de que quieres salir de la partida?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { action in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)    // Si pulsa 'Sí', quitamos la vista...
        }))
        self.present(alert, animated: true, completion: nil)
    }

    /**

     Comprueba la situación de la partida una vez se ha pulsado algún botón.

     */
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

    /**

     Actualiza la información de una partida después de pulsar el botón de una de las respuestas.
     Se comprueba si es un acierto, y siempre se añade el tiempo empleado para responder.

     */
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

    /**

     Consigue una nueva pregunta para mostrarse y prepara la vista (timer).

     */
    private func cambiaPregunta() {
        self.preguntaActual = partida!.getSiguientePregunta()!
        self.preparaVista(pregunta: self.preguntaActual!)
        self.tiempoRestante = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResponderPreguntaViewController.decrementaTiempo), userInfo: nil, repeats: true)
    }

    /**

     Devuelve el índice de un color aleatorio.

     */
    private func getColorAleatorio() -> Int {
        return Int(arc4random_uniform(UInt32(self.colorFondo.count)))
    }

    /**

     Modifica la información de la vista para mostrar una nueva pregunta. Esto es útil ya que nuestra vista se reutiliza para diferentes preguntas, no se crea una por cada pregunta de la base de datos.

     */
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

        // Primer color de fondo...
        let indiceColor = self.getColorAleatorio()
        fondoView.backgroundColor = colorFondo[indiceColor]
    }
}
