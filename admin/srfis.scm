;;;; Create SRFI repositories on Github
;;;;
;;;; based on download from srfi.schemers.org created using
;;;;   <wget --mirror srfi.schemers.org>

(load-option 'format)

;; Set this manually.
(define github-authorization-token #f)

(define github-api-srfi-repos
  "https://api.github.com/orgs/scheme-requests-for-implementation/repos")

(define-record-type srfi
    (%make-srfi number status title authors see-also keywords done-date draft-date)
    srfi?
  (number     srfi/number)
  (status     srfi/status)
  (title      srfi/title)
  (authors    srfi/authors)
  (see-also   srfi/see-also)
  (keywords   srfi/keywords)
  (done-date  srfi/done-date)
  (draft-date srfi/draft-date))		; final or withdrawn

(set-record-type-unparser-method!
 srfi
 (standard-unparser-method
  'srfi
  (lambda (srfi port)
    (write-char #\space port)
    (write (srfi/number srfi) port)
    (write-char #\space port)
    (write (srfi/title srfi) port))))

(define (make-srfi number
		   status
		   title
		   authors
		   see-also
		   keywords
		   draft-date
		   #!optional done-date)
  (%make-srfi number
	      status
	      title
	      authors
	      see-also
	      keywords
	      (and (not (default-object? done-date))
		   done-date)
	      draft-date))

(define srfis (map (lambda (l) (apply make-srfi l)) srfi-data))

(define srfi-keywords
  '(("algorithm" "Algorithm")
    ("arithmetic" "Arithmetic")
    ("assignment" "Assignment")
    ("binding" "Binding")
    ("comparison" "Comparison")
    ("concurrency" "Concurrency")
    ("continuations" "Continuations")
    ("control-flow" "Control Flow")
    ("data-structure" "Data Structure")
    ("error-handling" "Error Handling")
    ("exceptions" "Exceptions")
    ("features" "Features")
    ("i/o" "I/O")
    ("internationalization" "Internationalization")
    ("introspection" "Introspection")
    ("lazy-evaluation" "Lazy Evaluation")
    ("miscellaneous" "Miscellaneous")
    ("modules" "Modules")
    ("multiple-value-returns" "Multiple Value Returns")
    ("operating-system" "Operating System")
    ("optimization" "Optimization")
    ("parameters" "Parameters")
    ("pattern-matching" "Pattern Matching")
    ("reader-syntax" "Reader Syntax")
    ("syntax" "Syntax")
    ("testing" "Testing")
    ("type-checking" "Type Checking")
    ("superseded" "Superseded")))	; This one is of a different
					; category than the rest.

(define srfi-assoc
  (association-procedure = srfi/number))

(define (create-github-repository number)
  (let ((description (srfi/title (srfi-assoc number srfis))))
    (run-shell-command
     (format #f
	     "curl -i -H 'Authorization: token ~A' -d '{ \"name\": \"srfi-~A\", \"description\": \"~A\", \"has_issues\": false, \"has_wiki\": false }' ~A~%"
	     github-authorization-token
	     number
	     description
	     github-api-srfi-repos))))