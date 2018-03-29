//
//  GestionPreguntas.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation
import os.log

class GestionPreguntas {
    
    //MARK: Atributos
    
    private var preguntas = [Pregunta]()
    
    //MARK: Constructor
    
    init() {
        // Intentamos cargar las preguntas.
        if let preguntas = cargaPreguntas() {
            self.preguntas += preguntas
        }
    }
    
    //MARK: Métodos públicos
    
    func añadirPreguntas (preguntas: [Pregunta]) {
        self.preguntas += preguntas
    }
    
    func eliminarPregunta (index: Int) {
        self.preguntas.remove(at: index)
    }
    
    func getNumPreguntas() -> Int {
        return preguntas.count
    }
    
    func getPregunta(index: Int) -> Pregunta? {
        if index < preguntas.count {
            return preguntas[index]
        }
        
        return nil
    }
    
    func guardaPreguntas() {
        let exitoGuardado = NSKeyedArchiver.archiveRootObject(preguntas, toFile: Pregunta.ArchivoURL.path)
        
        if exitoGuardado {
            os_log("Preguntas guardadas con éxito.", log: OSLog.default, type: .debug)
        } else {
            os_log("Fallo al guardar las preguntas.", log: OSLog.default, type: .error)
        }
    }
    
    func modificarPregunta(pregunta: Pregunta, index: Int) {
        self.preguntas[index] = pregunta
    }
    
    //MARK: Métodos privados
    
    private func cargaPreguntas() -> [Pregunta]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pregunta.ArchivoURL.path) as? [Pregunta]
    }

}
