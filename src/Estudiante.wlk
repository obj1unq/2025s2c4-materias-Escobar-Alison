class Estudiante {
    const property carreras           = #{};
    const property materiasInscriptas = #{};
    const property materiasAprobadas  = #{}; 
    /*[
        Aprobada(materia = algebra, nota = 8),
        Aprobada(materia = pdep, nota = 10)
    ]*/

    method agregarCarrera(carrera) {
		carreras.add(carrera)
	}

    method aprobar(materia, nota) {
		materia.aprobar(self, nota)
	}

    method registrarMateriaAprobada(materia) {
      materiasAprobadas.add(materia)
    }

    method tieneAprobada(materia) = materiasAprobadas.any {aprobada => aprobada.materia().equals(materia)}

	method cantidadDeMateriasAprobadas() = materiasAprobadas.size()

	method promedioDeMateriasAprobadas() = self.sumaNotasDeMateriasAprobadas() / self.cantidadDeMateriasAprobadas()

	method sumaNotasDeMateriasAprobadas() = materiasAprobadas.sum{ aprobada => aprobada.nota() }

    method materiasDeCarrerasInscriptas() = carreras.flatMap{ carrera => carrera.materias() } //transforma cada elemento (map) y junta todo en una sola colección (flatten)


	method inscribirse(materia) {
		materia.inscribir(self)
		materiasInscriptas.add(materia)
	}

	method desuscribirse(materia) {
		materia.desuscribir(self)
		materiasInscriptas.remove(materia)
	}


}

/*
¿Cómo funciona la aprobacion de una materia para un estudiante?
pepe.aprobar(algebra, 8)

ESTUDIANTE
method aprobar(materia, nota) {
    materia.aprobar(self, nota) //algebra.aprobar(pepe, 8)
}

MATERIA
method aprobar(estudiante, _nota) {
    aprobacion.aprobar(estudiante, self, _nota) // aprobacion.aprobar(pepe, algebra, 8)
}

MATERIA-APROBADA, es el que valida 
method aprobar(estudiante, _materia, _nota) {
    self.validarPara(estudiante, _materia)
    
    estudiante.registrarMateriaAprobada( 
        new Aprobada(materia = _materia, nota = _nota) //Se crea una materia aprobada: nombreMateria + notaMateria
    )
}
*/