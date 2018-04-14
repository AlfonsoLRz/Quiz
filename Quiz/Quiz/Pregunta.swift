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
    
    static var siguienteId = 0          // Siguiente identificador asignable. Nótese que debería ser inicializado desde la clase que carga desde la BD, y por eso es público.
    
    var identificador : Int             // Identificador único de la pregunta.
    var titulo : String                 // Cadena con la pregunta.
    var imagen : UIImage?               // Imagen. Opcional.
    var categoria : String?             // Categoría donde se enmarca la pregunta. Opcional.
    var respuestas : [String]           // Vector con todas las respuestas de la pregunta. La primera será la verdadera.
    
    
    //MARK: Constructor
    
    /**
 
     Inicialización opcional de una pregunta. Se le deberán pasan todos los atributos anteriormente vistos, a excepción del identificador.
     A tener en cuenta:
     -Título no es opcional, y no puede estar vacío.
     -El número de respuestas debe ser 4.
     -Las respuestas no pueden estar vacías.
 
    */
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
    
    /**
 
     Inicializador secundario y opcional. Tomará un Resultado de la BD, y a partir del mismo se inicializa.
     
    */
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
