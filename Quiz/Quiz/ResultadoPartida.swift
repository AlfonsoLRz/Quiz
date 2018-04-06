//
//  ResultadoPartida.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation
import os.log

class ResultadoPartida: NSObject, NSCoding {
    
    //MARK: Atributos
    private var fecha : Date
    private var puntuación : Int
    
    //MARK: Persistencia
    
    struct PropertyKey {
        static let fecha = "fecha"
        static let puntuación = "puntuación"
    }
    
    //MARK: Rutas de guardado
    
    static let DirectorioDocumentos = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivoURL = DirectorioDocumentos.appendingPathComponent("resultados")
    
    
    init?(fecha : Date, puntuación: Int) {
        if puntuación < 0 {
            return nil
        }
        
        self.fecha = fecha
        self.puntuación = puntuación
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fecha, forKey: PropertyKey.fecha)
        aCoder.encode(puntuación, forKey: PropertyKey.puntuación)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // La fecha del resultado es obligatoria, luego si falla al descodificar no podemos seguir.
        guard let fecha = aDecoder.decodeObject(forKey: PropertyKey.fecha) as? Date else {
            os_log("No se ha podido obtener la fecha del resultado de la partida.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // La puntuación también es obligatoria.
        guard let puntuación = aDecoder.decodeObject(forKey: PropertyKey.puntuación) as? Int else {
            os_log("No se ha podido obtener el vector de respuestas.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(fecha: fecha, puntuación: puntuación)
    }}
