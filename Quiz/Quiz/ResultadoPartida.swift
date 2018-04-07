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
    private var categoría : String
    var puntuación : Int
    
    //MARK: Persistencia
    
    struct PropertyKey {
        static let categoría = "categoría"
        static let fecha = "fecha"
        static let puntuación = "puntuación"
    }
    
    //MARK: Rutas de guardado
    
    static let DirectorioDocumentos = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivoURL = DirectorioDocumentos.appendingPathComponent("resultadosPartidas")
    
    
    init?(categoría : String, fecha : Date, puntuación: Int) {
        if puntuación < 0 {
            return nil
        }
        
        self.categoría = categoría
        self.fecha = fecha
        self.puntuación = puntuación
    }
    
    
    //MARK: Métodos públicos
    
    func getCategoría() -> String {
        return self.categoría
    }
    
    func getFecha() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        return formatter.string(from: self.fecha)
    }
    
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoría, forKey: PropertyKey.categoría)
        aCoder.encode(fecha, forKey: PropertyKey.fecha)
        aCoder.encode(puntuación, forKey: PropertyKey.puntuación)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // La categoría del resultado es obligatoria.
        guard let categoría = aDecoder.decodeObject(forKey: PropertyKey.categoría) as? String else {
            os_log("No se ha podido obtener la categoría del resultado de la partida.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // La fecha del resultado es obligatoria, luego si falla al descodificar no podemos seguir.
        guard let fecha = aDecoder.decodeObject(forKey: PropertyKey.fecha) as? Date else {
            os_log("No se ha podido obtener la fecha del resultado de la partida.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // La puntuación también es obligatoria.
        let puntuación = aDecoder.decodeInteger(forKey: PropertyKey.puntuación)
        
        self.init(categoría: categoría, fecha: fecha, puntuación: puntuación)
    }
}
