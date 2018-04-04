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
    
    private var categorias = Set<String>()
    private var preguntas = [Pregunta]()
    
    
    //MARK: Constructor
    
    init() {
        // Intentamos cargar las preguntas.
        if let preguntas = cargaPreguntas() {
            self.preguntas += preguntas
            self.categorias = self.getCategorías()
        }
    }
    
    
    //MARK: Métodos públicos
    
    func añadirPreguntas(preguntas: [Pregunta]) {
        self.preguntas += preguntas
        self.categorias = self.getCategorías()
    }
    
    func eliminarPregunta(index: Int) {
        self.preguntas.remove(at: index)
        self.categorias = self.getCategorías()
    }
    
    func filtrarPorNombre(nombre: String) -> [Pregunta] {
        return preguntas.filter({(pregunta: Pregunta) -> Bool in return
            pregunta.titulo.lowercased().contains(nombre.lowercased())
        })
    }
    
    func filtrarPorCategoria(categoria: String) -> [Pregunta] {
        return preguntas.filter({(pregunta: Pregunta) -> Bool in return
            pregunta.categoria?.lowercased().contains(categoria.lowercased()) ?? false
        })
    }
    
    func getCategoria(index: Int) -> String {
        let array = Array(self.categorias)
        return array[index]
    }
    
    func getNumCategorias() -> Int {
        return self.categorias.count
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
        self.categorias = self.getCategorías()
    }
    
    func preguntaEncajaEnBusqueda(pregunta: Pregunta, busqueda: String, campo: String) -> Bool {
        let cadena = (campo == "Título") ? pregunta.titulo : pregunta.categoria ?? ""
        
        return cadena.lowercased().contains(busqueda.lowercased())
    }
    
    
    //MARK: Métodos privados
    
    private func cargaPreguntas() -> [Pregunta]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pregunta.ArchivoURL.path) as? [Pregunta]
    }
    
    private func getCategorías() -> Set<String> {
        // Dado que las categorías se pueden repetir las guardamos en un diccionario.
        // Por defecto la única categoría será Todas.
        var categorias : Set = ["Todas"]
        
        for  pregunta in self.preguntas {
            if let categoria = pregunta.categoria {
                categorias.insert(categoria)
            }
        }
        
        return categorias
    }

}
