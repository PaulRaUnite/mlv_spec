(lang dune 3.7)

(name mlv)

(generate_opam_files true)

(source
 (github PaulRaUnite/mlv_spec))

(authors "Pavlo Tokariev")

(maintainers "Pavlo Tokariev")

(version 0.1)

(license MIT)

(package
 (name mlv)
 (synopsis "Simulation of a fragment of Mechanical Lung Ventilator")
 (depends ocaml dune mrtccsl))
