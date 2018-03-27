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
    var foto : UIImage?
    var respuestas : [String]
    
    //MARK: Persistencia
    
    struct PropertyKey {
        static let titulo = "titulo"
        static let foto = "foto"
        static let respuestas = "respuestas"
    }
    
    //MARK: Rutas de guardado
    
    static let DirectorioDocumentos = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivoURL = DirectorioDocumentos.appendingPathComponent("preguntas")
    
    //MARK: Constructor
    
    init?(titulo: String, foto: UIImage?, respuestas : [String]) {
        self.titulo = titulo
        self.foto = foto
        self.respuestas = respuestas
        
        if respuestas.count != 4 {
            return nil
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(titulo, forKey: PropertyKey.titulo)
        aCoder.encode(foto, forKey: PropertyKey.foto)
        aCoder.encode(respuestas, forKey: PropertyKey.respuestas)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // El nombre de la pregunta es obligatorio, si falla al descodificar no podemos crearla.
        guard let titulo = aDecoder.decodeObject(forKey: PropertyKey.titulo) as? String else {
            os_log("No se ha podido obtener el titulo de la pregunta.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // La foto es opcional.
        let foto = aDecoder.decodeObject(forKey: PropertyKey.foto) as? UIImage
        
        // Las respuestas también son obligatorias.
        guard let respuestas = aDecoder.decodeObject(forKey: PropertyKey.respuestas) as? [String] else {
            os_log("No se ha podido obtener el vector de respuestas.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(titulo: titulo, foto: foto, respuestas: respuestas)
    }
}
