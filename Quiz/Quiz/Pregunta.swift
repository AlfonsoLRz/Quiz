//
//  Pregunta.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation
import os.log
import UIKit

class Pregunta : NSObject, NSCoding {

    //MARK: Atributos
    
    var titulo : String
    var imagen : UIImage?
    var categoria : String?
    var respuestas : [String]
    
    //MARK: Persistencia
    
    struct PropertyKey {
        static let titulo = "titulo"
        static let imagen = "imagen"
        static let categoria = "categoria"
        static let respuestas = "respuestas"
    }
    
    //MARK: Rutas de guardado
    
    static let DirectorioDocumentos = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivoURL = DirectorioDocumentos.appendingPathComponent("preguntas")
    
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
        
        self.titulo = titulo
        self.imagen = imagen
        self.categoria = categoria
        self.respuestas = respuestas
        mensaje = ""    // No había ningún fallo.
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(titulo, forKey: PropertyKey.titulo)
        aCoder.encode(imagen, forKey: PropertyKey.imagen)
        aCoder.encode(categoria, forKey: PropertyKey.categoria)
        aCoder.encode(respuestas, forKey: PropertyKey.respuestas)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // El nombre de la pregunta es obligatorio, si falla al descodificar no podemos crearla.
        guard let titulo = aDecoder.decodeObject(forKey: PropertyKey.titulo) as? String else {
            os_log("No se ha podido obtener el titulo de la pregunta.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // La foto es opcional.
        let imagen = aDecoder.decodeObject(forKey: PropertyKey.imagen) as? UIImage
        
        // La categoría también es opcional.
        let categoria = aDecoder.decodeObject(forKey: PropertyKey.categoria) as? String
        
        // Las respuestas también son obligatorias.
        guard let respuestas = aDecoder.decodeObject(forKey: PropertyKey.respuestas) as? [String] else {
            os_log("No se ha podido obtener el vector de respuestas.", log: OSLog.default, type: .debug)
            return nil
        }
        
        var mensaje = ""
        self.init(titulo: titulo, imagen: imagen, categoria: categoria, respuestas: respuestas, mensaje: &mensaje)
    }
}
