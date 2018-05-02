//
//  ResultadosViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class ResultadosViewController: UIViewController {

    //MARK: Atributos relacionados con la interfaz

    @IBOutlet weak var cabeceraLabel: UILabel!              // Título de la vista: varía en función de si es una victoria, derrota...
    @IBOutlet weak var descripciónLabel: UILabel!           // Descripción debajo del título. También depende del resultado.
    @IBOutlet weak var imagen: UIImageView!                 // Imagen de la vista. Igualmente varía en función de si es una victoria o una derrota.
    @IBOutlet weak var aciertosLabel: UILabel!              // Estadísticas: número de aciertos.
    @IBOutlet weak var puntuaciónLabel: UILabel!            // Estadísticas: puntuación obtenida.
    @IBOutlet weak var tiempoMedioLabel: UILabel!           // Estadísticas: tiempo medio por respuesta.


    //MARK: Atributos

    // Constantes
    private let CABECERA_VICTORIA = "¡Enhorabuena!"         // Título para una victoria.
    private let CABECERA_DERROTA = "¡Vaya!"                 // Título para la derrota.

    private let DESCRIPCIÓN_VICTORIA = "Has completado el test sin fallos"          // Descripción para una victoria.
    private let DESCRIPCIÓN_DERROTA = "No has completado el test sin fallos"        // Descripción para una derrota.

    var clasificacion : Clasificación?          // Gestor de resultados obtenidos por el jugador.
    var partida : Partida?                      // Partida desarrollada previamente (hasta llegar a esta vista).
    var victoria : Bool?                        // Resultado de la partida: victoria o derrota.


    /**

     Método que se ejecutará una vez se cargue la vista. Comprueba que tiene todas las variables que necesite para poder extraer información.

     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Comprobamos si tenemos los atributos necesarios.
        guard let _ = self.clasificacion else {
            fatalError("Necesitamos una clasificación adecuada para añadir los resultados de la partida actual.")
        }

        guard let _ = self.partida else {
            fatalError("Necesitamos los datos de la partida para mostrar las estadísticas.")
        }

        guard let _ = self.victoria else {
            fatalError("Necesitamos conocer si es una victoria o una derrota para mostrar los mensajes oportunos.")
        }

        //IMPORTANTE: Guardamos los resultados de esta partida en la clasificación.
        self.clasificacion!.añadeResultado(categoría: self.partida!.getCategoría(), puntuación: self.partida!.getPuntuación())

        // Labels dependientes del resultado de la partida.
        if self.victoria! {
            self.cabeceraLabel.text = CABECERA_VICTORIA
            self.descripciónLabel.text = DESCRIPCIÓN_VICTORIA
        } else {
            self.cabeceraLabel.text = CABECERA_DERROTA
            self.descripciónLabel.text = DESCRIPCIÓN_DERROTA
        }

        // Imagen: sólo la cambiamos si es una derrota, ya que por defecto será el trofeo de victoria.
        if !self.victoria! {
            self.imagen.image = UIImage(named: "EmojiRespuestaFallida")
        }

        // Estadísticas.
        self.aciertosLabel.text = "Aciertos: \(self.partida!.getAciertos())"
        self.puntuaciónLabel.text = "Puntuación: \(self.partida!.getPuntuación())"
        self.tiempoMedioLabel.text = "Tiempo medio de respuesta: \(self.partida!.getTiempoMedio()) s"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Navigation

    /**

     Preparación para dirigirnos hacia otra vista.

     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case"ConsultarRanking":
            let destinationNavigation = segue.destination as? UINavigationController
            guard let clasificaciónController = destinationNavigation?.topViewController as? ClasificaciónTableViewController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }

            clasificaciónController.clasificacion = self.clasificacion
        case "VolverAJugar":
            print(segue.destination)
            guard let homeController = segue.destination as? HomeController else {
                fatalError("Destino de navegación inesperado: \(segue.destination)")
            }

            homeController.segueARealizar = "SeleccionarCategoría"
        default:
            fatalError("Identificador de segue desconocido: \(String(describing: segue.identifier))")
        }
    }


    //MARK: Actions

    /**

     Evento de pulsar el botón de compartir. Nos saldrá una ventana con todas las aplicaciones donde podemos hacer alguna acción.

     */
    @IBAction func compartir(_ sender: UIButton) {
        // Debe haber al menos un usuario loggeado...
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            self.componerMensajeTwitter()
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().login { session, error in
                if let session = session {
                  self.componerMensajeTwitter()
                }
            }
        }
    }

    /**

     Muestra una ventana para publicar un tweet con un mensaje por defecto y una imagen.

     */
        guard let imagen = UIImage(named: "DefaultImage") else {
            print("Fallo al crear la imagen para compartir")
            return
        }

        let composer = TWTRComposerViewController.init(initialText: "¡Acabo de conseguir una puntuación de \(self.partida!.getPuntuación()) con \(self.partida!.getTiempoMedio()) aciertos!", image: imagen, videoURL: nil)
        composer.delegate = self
        present(composer, animated: true, completion: nil)
    }

    /**

     Evento que se ejecuta al pulsar el botón de Salir. Nos dirige hacia Home.

     */
    @IBAction func salir(_ sender: UIBarButtonItem) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    /**

     Evento que se ejecutará cuando se pulse el botón de Volver a jugar. Vuelve a Home, y se ejecuta el segue de Jugar.

     */
    @IBAction func volverAJugar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "VolverAJugar", sender: sender)
    }
}
