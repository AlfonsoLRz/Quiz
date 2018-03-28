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
    
    // Último textField presionado.
    private var ultimoTextFieldUsado : UITextField?
    
    
    //MARK: Otros atributos.
    
    var mensajeCreacion : String?
    var pregunta : Pregunta?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Segue para mostrar el pop over.
        if let popOver = segue.destination as? PopOverViewController {
            print(mensajeCreacion!)
            popOver.mensaje = self.mensajeCreacion ?? "Fallo al crear la pregunta."
            
            // Limpiamos las variables...
            self.pregunta = nil
            self.mensajeCreacion = nil
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Comprobamos si se puede añadir la pregunta...
        if identifier == "VolverLista" {
            if let mensaje = creaPregunta() {
                self.mensajeCreacion = mensaje
            }
            return self.mensajeCreacion == nil
            
        // Fallo al crear la pregunta. ¿Es correcto hacer esta navegación?
        } else if identifier == "FalloPregunta" {
            if let mensaje = creaPregunta() {
                self.mensajeCreacion = mensaje
            }
            return self.mensajeCreacion != nil
        }
        
        return false
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
        
        // Hacemos desaparecer la ventana de selección de imágenes.
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: Actions
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        // Comprobamos si la pregunta está ya creada...
        guard self.pregunta == nil else {
            return self.mensajeCreacion
        }
        
        // Creamos la pregunta...
        let titulo = tituloPregunta.text ?? ""
        let imagen = imagenPregunta.image
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
