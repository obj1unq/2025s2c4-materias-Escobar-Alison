class Universidad {

	const property carreras = #{}
	const property estudiantes = #{}

	method agregarCarrera(carrera) {
		carreras.add(carrera)
	}
	
	method inscribir(estudiante) {
		estudiantes.add(estudiante)
	}

}