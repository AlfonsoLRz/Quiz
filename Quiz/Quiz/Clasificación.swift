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
        // Cargamos los resultados desde fichero desde fichero.
        if let resultados = cargaResultados() {
            self.resultados += resultados
            self.ordenaResultados()
        }
    }
    
    
    //MARK: Métodos públicos
    
    func añadeResultado(categoría: String, puntuación: Int) {
        if let resultado = ResultadoPartida(categoría: categoría, fecha: Date(), puntuación: puntuación) {
            self.resultados.append(resultado)
            self.ordenaResultados()
        } else {
            os_log("Fallo al insertar el nuevo resultado.", log: OSLog.default, type: .error)
        }
    }
    
    func filtrarPorCategoria(categoria: String) -> [ResultadoPartida] {
        return self.resultados.filter({(resultado: ResultadoPartida) -> Bool in return
            resultado.getCategoría().lowercased().contains(categoria.lowercased())
        })
    }
    
    func eliminaResultado(index: Int) {
        self.resultados.remove(at: index)
    }
    
    func getNumResultados() -> Int {
        return resultados.count
    }
    
    func getResultado(index: Int) -> ResultadoPartida? {
        if index < self.resultados.count {
            return self.resultados[index]
        }
        
        return nil
    }
    
    func guardaResultados() {
        let exitoGuardado = NSKeyedArchiver.archiveRootObject(self.resultados, toFile: ResultadoPartida.ArchivoURL.path)
        
        if exitoGuardado {
            os_log("Resultados guardados con éxito.", log: OSLog.default, type: .debug)
        } else {
            os_log("Fallo al guardar los resultados.", log: OSLog.default, type: .error)
        }
    }
    
    func índiceDeResultado(resultado: ResultadoPartida) -> Int? {
        return self.resultados.index(of: resultado)
    }
    
    
    //MARK: Métodos privados
    
    private func cargaResultados() -> [ResultadoPartida]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ResultadoPartida.ArchivoURL.path) as? [ResultadoPartida]
    }
    
    private func ordenaResultados() {
        self.resultados.sort(by: {$0.puntuación > $1.puntuación })
    }
}
