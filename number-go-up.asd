;;;; number-go-up.asd

(asdf:defsystem #:number-go-up
  :description ""
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:uiop #:nodgui)
  :components ((:file "package")
               (:file "main")
			   (:file "utilities")))
