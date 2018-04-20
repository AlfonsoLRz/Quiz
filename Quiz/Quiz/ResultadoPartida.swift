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
    
    static var siguienteId = 0              // Siguiente identificador que se puede asignar a un resultado.
    
    var identificador : Int                 // Identificador del resultado.
    var fecha : String                      // Timestamp en la que se guardó el resultado.
    var categoría : String                  // Categoría a la que pertenece la partida relacionada con el resultado.
    var puntuación : Int                    // Puntuación obtenida en la partida.
    
    
    /**
 
     Constructor de un resultado. Nótese que si alguno de los parámetros es incorrecto (puntuación), no se completa la construcción de la pregunta.
 
     */
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
    
    /**
     
     Inicializador secundario donde se recibe la fecha como un objeto Date en lugar de una cadena.
 
     */
    convenience init?(categoría: String, fecha: Date, puntuación: Int) {
        self.init(categoría: categoría, fecha: ResultadoPartida.getFecha(fecha: fecha), puntuación: puntuación)
    }
    
    /**
 
     Inicializador secundario donde se construye un resultado a partir de un objeto resultado en la base de datos.
 
     */
    convenience init?(resultadoDB: NSManagedObject) {
        let fecha = resultadoDB.value(forKeyPath: "fecha") as? String
        let puntuacion = resultadoDB.value(forKeyPath: "puntuacion") as? Int
        let categoria = resultadoDB.value(forKeyPath: "categoria") as? String
        
        self.init(categoría: categoria!, fecha: fecha!, puntuación: puntuacion!)
        
        // Adjuntamos el identificador.
        self.identificador = resultadoDB.value(forKeyPath: "identificador") as! Int
        ResultadoPartida.siguienteId -= 1
    }
    
    
    //MARK: Métodos públicos
    
    /**
 
     Devuelve la categoría a la que pertenece la partida en la que se obtuvo el resultado.
 
     */
    func getCategoría() -> String {
        return self.categoría
    }
    
    /**
     
     Devuelve la fecha en la que se guardó el resultado de la partida.
 
     */
    static func getFecha(fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        return formatter.string(from: fecha)
    }
}
