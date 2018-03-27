//
//  PreguntaViewController.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import UIKit

class PreguntaViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Atributos de la interfaz
    
    @IBOutlet weak var tituloPregunta: UITextField!
    @IBOutlet weak var categoriaPregunta: UITextField!
    @IBOutlet weak var imagenPregunta: UIImageView!
    @IBOutlet weak var respuestaCorrecta: UITextField!
    @IBOutlet weak var respuestaFalsa1: UITextField!
    @IBOutlet weak var respuestaFalsa2: UITextField!
    @IBOutlet weak var respuestaFalsa3: UITextField!
    
    // Último textField presionado.
    var ultimoTextFieldUsado : UITextField?
    
    
    //MARK: Otros atributos.
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
