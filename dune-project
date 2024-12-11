(lang dune 3.18)

(name desert-cache)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name desert-cache)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ;; The version in Nixpkgs
   (ocaml (= 5.2.1))
   dream
   caqti-driver-sqlite3)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
