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
    
    func añadirPreguntas(preguntas: [Pregunta]) {
        self.preguntas += preguntas
    }
    
    func eliminarPregunta(index: Int) {
        self.preguntas.remove(at: index)
    }
    
    func filtrarPorNombre(nombre: String) -> [Pregunta] {
        print("Filtar por nombre: \(nombre)")
        return preguntas.filter({(pregunta: Pregunta) -> Bool in return
            pregunta.titulo.lowercased().contains(nombre.lowercased())
        })
    }
    
    func filtrarPorCategoria(categoria: String) -> [Pregunta] {
        return preguntas.filter({(pregunta: Pregunta) -> Bool in return
            pregunta.categoria?.lowercased().contains(categoria.lowercased()) ?? false
        })
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
    
    func indiceDePregunta(pregunta: Pregunta) -> Int? {
        return self.preguntas.index(of: pregunta)
    }
    
    func modificarPregunta(pregunta: Pregunta, index: Int) {
        self.preguntas[index] = pregunta
    }
    
    func preguntaEncajaEnBusqueda(pregunta: Pregunta, busqueda: String, campo: String) -> Bool {
        let cadena = (campo == "Título") ? pregunta.titulo : pregunta.categoria ?? ""
        
        return cadena.lowercased().contains(busqueda.lowercased())
    }
    
    //MARK: Métodos privados
    
    private func cargaPreguntas() -> [Pregunta]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pregunta.ArchivoURL.path) as? [Pregunta]
    }

}
