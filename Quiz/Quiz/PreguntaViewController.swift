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
    @IBOutlet var botonGuardar: UIBarButtonItem!
    
    // Formulario
    @IBOutlet weak var tituloPregunta: UITextField!
    @IBOutlet weak var categoriaPregunta: UITextField!
    @IBOutlet weak var imagenPregunta: UIImageView!
    @IBOutlet weak var respuestaCorrecta: UITextField!
    @IBOutlet weak var respuestaFalsa1: UITextField!
    @IBOutlet weak var respuestaFalsa2: UITextField!
    @IBOutlet weak var respuestaFalsa3: UITextField!
    
    // Modificaciones de componentes.
    private var imagenModificada = false
    private var ultimoTextFieldUsado : UITextField?
    
    
    //MARK: Otros atributos.

    var pregunta : Pregunta?
    
    
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
            self.pregunta = nil
            
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Animación para hacer desaparecer la ventana de selección de imágenes.
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ultimoTextFieldUsado = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Esconde el teclado.
        textField.resignFirstResponder()
        
        return true
    }
    
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
