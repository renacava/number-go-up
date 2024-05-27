(in-package #:number-go-up)

(defparameter *health-number* 5)
(defparameter *hit-number* 0)
(defparameter *monster-hit-number* 4)

(defun main ()
  (reset)
  (print "You are on an adventure. You have 5 health, 0 hit number and the current monster has target-number 4. Roll higher than the monster's target-number to slay it and move on to the next monster."))

(defun fight-monster ()
  (let* ((result (1+ (random 10)))
         (total (+ result *hit-number*)))
    (print (format nil "The monster has ~a health.~%You hit for ~a + ~a = ~a." *monster-hit-number* result *hit-number* total))
    (if (> total *monster-hit-number*)
        (slay-monster)
        (take-damage))))

(defun slay-monster ()
  (print "You slay the monster.")
  (incf *hit-number*)
  (incf *monster-hit-number*)
  (if (> *monster-hit-number* 26)
      (win)
      (narrate)))

(defun narrate ()
  (print (format nil "You have ~a health" *health-number*))
  (print (format nil "You now have a hit-number of ~a" *hit-number*))
  (print (format nil "You come across a monster with a hit-number of ~a" *monster-hit-number*)))

(defun take-damage ()
  (print (format nil "You fail to slay the monster and take 1 damage. You now have ~a health." (decf *health-number*)))
  (unless (> *health-number* 0)
    (lose)))

(defun win ()
  (print "You win.")
  (main))

(defun lose ()
  (print "You lose.")
  (main))

(defun reset ()
  (setf *health-number* 5
        *hit-number* 0
        *monster-hit-number* 4))

(defmacro with-nodgui-thread (&body body)
  `(sb-thread:make-thread
    (lambda ()
      (with-nodgui ()
        (wm-title *tk* "Number Go Up")
        ,@body))))

(defun get-current-time-seconds ()
  (float (/ (get-internal-real-time) internal-time-units-per-second)))

(defun get-thread-by-name (thread-name)
  (loop for thread in (sb-thread:list-all-threads)
        when (string= thread-name (sb-thread:thread-name thread))
        do (return-from get-thread-by-name thread)))

(defun destroy-thread-by-name (thread-name)
  (let ((thread (get-thread-by-name thread-name)))
    (when thread
      (sb-thread:terminate-thread thread))))

(defun make-quit-button ()
  (let ((button (make-instance 'button :text "QUIT" :command (lambda () (exit-nodgui)))))
    (grid button 0 2)
    button))

(defun main ()
  (with-nodgui-thread ()
    (let ((content (make-instance 'frame)))
      (configure content :padding "3 3 12 12")
      (grid content 0 0 :sticky "nsew")
      (grid-columnconfigure *tk* 0 :weight 1)
      (grid-rowconfigure *tk* 0 :weight 1)

      (grid (make-instance 'button :text "quit" :master content :command (lambda () (exit-nodgui))) 0 0))))
