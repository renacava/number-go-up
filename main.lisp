(in-package #:number-go-up)

(defparameter *health-number* 5)
(defparameter *hit-number* 0)
(defparameter *monster-hit-number* 4)
(defparameter *textbox* nil)

(defun main ()
  (sb-thread:make-thread
   (lambda ()
     (with-nodgui ()
       (wm-title *tk* "Number Go Up")
       (let* ((content (make-instance 'frame))
              (fight-button (make-instance 'button :master content :text "Fight monster" :command #'fight-monster))
              (log (make-instance 'scrolled-text :height 24 :width 80 :wrap :word :state :disabled :master content ))
              (repl (make-instance 'entry :master content :width 60)))
         (bind *tk* "<Return>" (lambda (event) (setf (text repl) (evaluate-string-in-package (text repl) :number-go-up))))
         (setf *textbox* log)
         (configure content :padding "3 3 12 12")
         (grid content 0 0 :sticky "nsew")
         (grid-columnconfigure *tk* 0 :weight 1)
         (grid-rowconfigure *tk* 0 :weight 1)
         (grid log 0 0 :sticky "nsew")
         (grid fight-button 1 0 :sticky "we")
         (grid repl 2 0 :sticky "we")
         (adventure))))))

(defun adventure ()
  (reset)
  (log-text "You are on an adventure. You have 5 health, 0 hit number and the current monster has target-number 4. Roll higher than the monster's target-number to slay it and move on to the next monster."))

(defun fight-monster ()
  (let* ((result (1+ (random 10)))
         (total (+ result *hit-number*)))
    (log-text (format nil "The monster has ~a health.~%You hit for ~a + ~a = ~a." *monster-hit-number* result *hit-number* total))
    (if (> total *monster-hit-number*)
        (slay-monster)
        (take-damage))))

(defun slay-monster ()
  (log-text "You slay the monster.")
  (incf *hit-number*)
  (incf *monster-hit-number*)
  (if (>= *monster-hit-number* 26)
      (win)
      (narrate)))

(defun narrate ()
  (log-text (format nil "You have ~a health" *health-number*))
  (log-text (format nil "You now have a hit-number of ~a" *hit-number*))
  (log-text (format nil "You come across a monster with a hit-number of ~a" *monster-hit-number*)))

(defun take-damage ()
  (log-text (format nil "You fail to slay the monster and take 1 damage. You now have ~a health." (decf *health-number*)))
  (unless (> *health-number* 0) (lose)))

(defun win ()
  (log-text "You win.")
  (adventure))

(defun lose ()
  (log-text "You lose.")
  (adventure))

(defun reset ()
  (setf *health-number* 5
        *hit-number* 0
        *monster-hit-number* 4))

(defun log-text (text)
  (configure *textbox* :state :normal)
  (append-text *textbox* text)
  (append-newline *textbox*)
  (nodgui:see *textbox* "end")
  (configure *textbox* :state :disabled))


(defun evaluate-string-in-package (string package)
  (format nil "~a" (ignore-errors (eval (read-from-string (format nil "(progn (in-package ~a) ~a)" package string))))))
