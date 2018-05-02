//
//  PreguntaViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import os.log
import UIKit

class PreguntaViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Atributos de la interfaz

    // Barra de navegación
    @IBOutlet var botonGuardar: UIBarButtonItem!                    // Botón para guardar la pregunta.

    // Formulario
    @IBOutlet weak var tituloPregunta: UITextField!                 // Título de la pregunta.
    @IBOutlet weak var categoriaPregunta: UITextField!              // Categoría de la pregunta.
    @IBOutlet weak var imagenPregunta: UIImageView!                 // Imagen de la pregunta.
    @IBOutlet weak var respuestaCorrecta: UITextField!              // Respuesta correcta.
    @IBOutlet weak var respuestaFalsa1: UITextField!                // Respuestas falsas...
    @IBOutlet weak var respuestaFalsa2: UITextField!
    @IBOutlet weak var respuestaFalsa3: UITextField!

    // Modificaciones de componentes.
    private var imagenModificada = false                            // ¿Se ha elegido una imagen diferente de la de por defecto?
    private var ultimoTextFieldUsado : UITextField?                 // Último text field que se ha manipulado.


    //MARK: Otros atributos.

    var pregunta : Pregunta?                                        // Pregunta con la información contenida en los text fields y otros campos.


    /**

     Método que se ejecutará al cargar la vista. Inicializa todos los campos de la vista.

     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Recibir eventos de los text fields...
        tituloPregunta.delegate = self
        categoriaPregunta.delegate = self
        respuestaCorrecta.delegate = self
        respuestaFalsa1.delegate = self
        respuestaFalsa2.delegate = self
        respuestaFalsa3.delegate = self

        // Si la pregunta ya existe, es decir, es una modificación, se muestran los datos de la misma.
        if let pregunta = self.pregunta {
            tituloPregunta.text = pregunta.titulo
            categoriaPregunta.text = pregunta.categoria
            imagenPregunta.image = pregunta.imagen ?? UIImage(named: "NoImagen")
            respuestaCorrecta.text = pregunta.respuestas[0]
            respuestaFalsa1.text = pregunta.respuestas[1]
            respuestaFalsa2.text = pregunta.respuestas[2]
            respuestaFalsa3.text = pregunta.respuestas[3]

            self.imagenModificada = pregunta.imagen != nil

            // Configuramos el título de la barra de navegación.
            self.navigationItem.title = "Modificar pregunta"
        } else {
            self.navigationItem.title = "Añadir pregunta"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: Navigation

    /**

     Preparación para dirigirnos a otra vista (segue).

     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

    /**

     ¿Se puede ejecutar un segue? Dependerá de si la información introducida es correcta. Se comprueba si esto es así creando una pregunta
     con la información de la vista.

     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Si el mensaje no es nulo la creación de pregunta no ha tenido éxito.
        if let mensaje = creaPregunta() {
            // Creamos la alerta con el fallo al crear la pregunta.
            let alert = UIAlertController(title: "Error al crear la pregunta", message: mensaje, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return false
        }

        return true
    }


    //MARK: UIImagePickerControllerDelegate

    /**

     Cancelar selección de imagen, por lo que se elimina la ventana que se encargaba de ello.

     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Animación para hacer desaparecer la ventana de selección de imágenes.
        dismiss(animated: true, completion: nil)
    }

    /**

     Selección de una imagen concreta dentro de la librería. Se actualiza la imagen almacenada.

     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // El diccionario podría incluir múltiples representaciones de la imagen, pero queremos la original.
        guard let imagenSleccionada = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Esperaba un diccionario que contuviera una imagen, pero hemos encontrado lo siguiente: \(info)")
        }

        // Modificamos la imagen en la vista.
        imagenPregunta.image = imagenSleccionada
        imagenModificada = true

        // Hacemos desaparecer la ventana de selección de imágenes.
        dismiss(animated: true, completion: nil)
    }


    //MARK: Actions

    /**

     Evento al pulsar el botón de Cancelar. Se deshechan los cambios realizados.

     */
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        // Mostramos una alerta si se han introducido datos...
        if (self.haIntroducidoDatos()) {
            // Creamos la alerta para preguntarle si de verdad quiere cancelar
            let alert = UIAlertController(title: "Cancelar", message: "¿Estás seguro de que no quieres guardar la pregunta?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: retirarVista))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.retirarVista(alert: nil)
        }
    }

    /**

     Devuelve un booleano en función de si han incluido datos nuevos o no.

     */
    func haIntroducidoDatos() -> Bool {
        if (navigationItem.title == "Añadir pregunta") {
            return (!(self.tituloPregunta.text?.isEmpty)!) || (self.imagenModificada) || (!(self.categoriaPregunta.text?.isEmpty)!)
                   || (!(self.respuestaCorrecta.text?.isEmpty)!) || (!(self.respuestaFalsa1.text?.isEmpty)!)
                   || (!(self.respuestaFalsa2.text?.isEmpty)!) || (!(self.respuestaFalsa3.text?.isEmpty)!)
        } else {
            if let pregunta = self.pregunta {
                return (self.tituloPregunta.text != pregunta.titulo) || (self.imagenPregunta.image != pregunta.imagen)
                       || (self.categoriaPregunta.text != pregunta.categoria) || (self.respuestaCorrecta.text != pregunta.respuestas[0])
                       || (self.respuestaFalsa1.text != pregunta.respuestas[1]) || (self.respuestaFalsa2.text != pregunta.respuestas[2])
                       || (self.respuestaFalsa3.text != pregunta.respuestas[3])
            }
        }

        return false
    }

    /**

     Elimina la vista, teniendo en cuenta el tipo de segue del que apareció.

     */
    func retirarVista(alert: UIAlertAction?) {
        // Si responde que sí debemos quitar la vista...
        if self.navigationItem.title == "Añadir pregunta" {
            dismiss(animated: true, completion: nil)
        } else if self.navigationItem.title == "Modificar pregunta" {
            if let owningViewController = self.navigationController {
                owningViewController.popViewController(animated: true)
            }
        } else {
            fatalError("La vista PreguntaViewController no está en ninguna controlador de navegación. ")
        }
    }

    /**

     Comienzo de modificación de un text field.

     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ultimoTextFieldUsado = textField
    }

    /**

     Esconde el teclado al terminar de modificar un text field.

     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Esconde el teclado.
        textField.resignFirstResponder()

        return true
    }

    /**

     Prepara la creación de una ventana donde se pueda escoger una imagen.

     */
    @IBAction func seleccionaImagenDeLibreria(_ sender: UITapGestureRecognizer) {
        // Esconder el teclado.
        if let textField = ultimoTextFieldUsado {
            textField.resignFirstResponder()
        }

        // UIImagePickerController para poder coger datos de la librería de imágenes.
        let imagePickerController = UIImagePickerController()
        // Sólo debemos permitir coger imágenes.
        imagePickerController.sourceType = .photoLibrary

        // Nos debe informar cuando se escoge una imagen.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }


    //MARK: Métodos privados

    /**

     Intenta crear una pregunta con la información de la vista. Devuelve un mensaje de error si no se puede crear la pregunta.

     */
    private func creaPregunta() -> String? {
        // Creamos la pregunta...
        let titulo = tituloPregunta.text ?? ""
        let imagen = ((imagenModificada) ? imagenPregunta.image : nil)
        let categoria = categoriaPregunta.text ?? ""
        let respuestas = [respuestaCorrecta.text ?? "", respuestaFalsa1.text ?? "", respuestaFalsa2.text ?? "", respuestaFalsa3.text ?? ""]
        var mensaje = ""

        if let pregunta = Pregunta(titulo: titulo, imagen: imagen, categoria: categoria, respuestas: respuestas, mensaje: &mensaje) {
            self.pregunta = pregunta

            return nil
        }

        return mensaje
    }
}
