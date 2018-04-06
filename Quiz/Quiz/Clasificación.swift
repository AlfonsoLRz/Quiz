//
//  Clasificación.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation
import os.log

class Clasificación {
    
    //MARK: Atributos
    private var resultados = [ResultadoPartida]()
    
    
    init() {
        /// Cargamos los resultados desde fichero desde fichero.
        if let resultados = cargaResultados() {
            self.resultados = resultados
        }
    }
    
    
    //MARK: Métodos públicos
    
    func añadeResultado(puntuación: Int) {
        if let resultado = ResultadoPartida(fecha: Date(), puntuación: puntuación) {
            self.resultados.append(resultado)
        } else {
            os_log("Fallo al insertar el nuevo resultado.", log: OSLog.default, type: .error)
        }
    }
    
    func guardaResultados() {
        let exitoGuardado = NSKeyedArchiver.archiveRootObject(self.resultados, toFile: ResultadoPartida.ArchivoURL.path)
        
        if exitoGuardado {
            os_log("Resultados guardados con éxito.", log: OSLog.default, type: .debug)
        } else {
            os_log("Fallo al guardar los resultados.", log: OSLog.default, type: .error)
        }
    }
    
    
    //MARK: Métodos privados
    
    private func cargaResultados() -> [ResultadoPartida]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ResultadoPartida.ArchivoURL.path) as? [ResultadoPartida]
    }
}
