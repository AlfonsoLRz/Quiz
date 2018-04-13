//
//  ResultadoPartida.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import CoreData
import Foundation
import os.log

class ResultadoPartida {
    
    //MARK: Atributos
    
    static var siguienteId = 0
    
    var identificador : Int
    var fecha : String
    var categoría : String
    var puntuación : Int
    
    
    init?(categoría: String, fecha: String, puntuación: Int) {
        if puntuación < 0 {
            return nil
        }
        
        self.identificador = ResultadoPartida.siguienteId
        ResultadoPartida.siguienteId = ResultadoPartida.siguienteId + 1
        self.categoría = categoría
        self.fecha = fecha
        self.puntuación = puntuación
    }
    
    convenience init?(categoría: String, fecha: Date, puntuación: Int) {
        self.init(categoría: categoría, fecha: ResultadoPartida.getFecha(fecha: fecha), puntuación: puntuación)
    }
    
    convenience init?(resultadoDB: NSManagedObject) {
        let fecha = resultadoDB.value(forKeyPath: "fecha") as? String
        let puntuacion = resultadoDB.value(forKeyPath: "puntuacion") as? Int
        let categoria = resultadoDB.value(forKeyPath: "categoria") as? String
        
        self.init(categoría: categoria!, fecha: fecha!, puntuación: puntuacion!)
    }
    
    
    //MARK: Métodos públicos
    
    func getCategoría() -> String {
        return self.categoría
    }
    
    static func getFecha(fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        return formatter.string(from: fecha)
    }
}
