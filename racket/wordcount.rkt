#lang racket

;; Initial implementation by @1player

(define (update-word-count! s table)
  (for ([word (string-split s)])
    (hash-update! table
                  word
                  (λ (count) (+ 1 count))
                  0)))

(define (reverse-cmp-pair x y)
  (let ([freqx (cdr x)]
        [freqy (cdr y)]
        [wordx (car x)]
        [wordy (car y)])
    (or (> freqx freqy)
        (and (= freqx freqy)
             (string<=? wordx wordy)))))

(define (dump-table table)
  (for ([pair (sort (hash->list table) reverse-cmp-pair)])
    (printf "~a\t~a\n" (car pair) (cdr pair))))

(define (main table)
  (define line (read-line))
  (if (eof-object? line)
      (dump-table table)
      (begin
        (update-word-count! line table)
        (main table))))

(main (make-hash))
