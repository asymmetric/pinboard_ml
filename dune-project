(lang dune 3.18)

(name pinboard_ml)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name pinboard_ml)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   (ocaml (= 5.1.1))
   dream
   caqti-driver-sqlite3)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
