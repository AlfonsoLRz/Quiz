//
//  Pregunta.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import CoreData
import Foundation
import os.log
import UIKit

class Pregunta {

    //MARK: Atributos
    
    static var siguienteId = 0
    
    var identificador : Int
    var titulo : String
    var imagen : UIImage?
    var categoria : String?
    var respuestas : [String]
    
    
    //MARK: Constructor
    
    init?(titulo: String, imagen: UIImage?, categoria: String?, respuestas : [String], mensaje: inout String) {
        // Comprobaciones de correción de parámetros.
        guard !titulo.isEmpty else {
            mensaje = "El título de la pregunta no puede estar vacío."
            return nil
        }
        
        guard respuestas.count == 4 else {
            mensaje = "El número de respuestas debe de ser 4."
            return nil
        }
        
        // Las respuestas tampoco pueden estar vacías.
        for respuesta in respuestas {
            if respuesta.isEmpty {
                mensaje = "Ninguna respuesta puede quedar vacía."
                return nil
            }
        }
        
        if let valorCategoria = categoria {
            if valorCategoria == "Todas" {
                mensaje = "Esta categoría está reservada para seleccionar todas las preguntas."
                return nil
            }
        }
        
        self.identificador = Pregunta.siguienteId
        self.titulo = titulo
        self.imagen = imagen
        self.categoria = categoria
        self.respuestas = respuestas
        mensaje = ""    // No había ningún fallo.
        
        Pregunta.siguienteId = Pregunta.siguienteId + 1
    }
    
    convenience init?(preguntaBD: NSManagedObject) {
        let titulo = preguntaBD.value(forKeyPath: "titulo") as? String
        let imagenData = preguntaBD.value(forKeyPath: "imagen") as? Data
        let imagen = (imagenData != nil) ? UIImage(data: imagenData!) : nil
        let categoria = preguntaBD.value(forKeyPath: "categoria") as? String?
        
        // Respuestas.
        let respuesta1 = preguntaBD.value(forKeyPath: "respuesta1") as? String
        let respuesta2 = preguntaBD.value(forKeyPath: "respuesta2") as? String
        let respuesta3 = preguntaBD.value(forKeyPath: "respuesta3") as? String
        let respuesta4 = preguntaBD.value(forKeyPath: "respuesta4") as? String
        
        var mensaje = ""
        self.init(titulo: titulo!, imagen: imagen, categoria: categoria!, respuestas: [respuesta1!, respuesta2!, respuesta3!, respuesta4!], mensaje: &mensaje)
    }
}
