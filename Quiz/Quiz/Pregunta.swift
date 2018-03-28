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
    
    init?(titulo: String, imagen: UIImage?, categoria: String?, respuestas : [String]?) {
        self.titulo = titulo
        self.imagen = imagen
        self.categoria = categoria
        self.respuestas = [String]()
        
        // Comprobamos si el vector de respuestas es correcto (tamaño y valor).
        /*if let _ = respuestas {
            if respuestas!.count != 4 {
                return nil
            } else {
                self.respuestas = respuestas!
            }
        } else {
            return nil
        }*/
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
        
        self.init(titulo: titulo, imagen: imagen, categoria: categoria, respuestas: respuestas)
    }
}
