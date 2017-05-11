#!/usr/bin/env bash
# -*- mode: scheme -*-
exec guile $0
# !#

;;; wordcount.scm --- meeting the challenge with Guile, fast version

;; Copyright (C) 2017
;; Arne Babenhauserheide <arne_bab@web.de> and Linus Björnstam

;; Author: Arne Babenhauserheide <arne_bab@web.de> and Linus Björnstam

;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 3 of the License, or (at your option) any later version.

;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.

;; You should have received a copy of the GNU Lesser General Public
;; License along with this library. If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; The wordcount challenge pits programming languages against each
;; other in a battle of counting words in unicode text.
;;
;; See https://github.com/juditacs/wordcount
;;
;; wordcount_reference.scm holds an alternative version written for
;; clarity but not speed.

;;; Code:

(import (ice-9 rdelim)
        (ice-9 hash-table)
        (srfi srfi-1))

(define (count-or-unicode>? a b)
  (let ((Na (cdr a))(Nb (cdr b)))
    (cond
     [(> Na Nb) #t]
     [(= Na Nb) (string<? (car a) (car b))]
     [else #f])))

(define (skip-whitespace port)
  (let ([ch (peek-char port)])
    (when (and (not (eof-object? ch)) (char-whitespace? ch))
      (read-char port)
      (skip-whitespace port))))

(define (count-words port)
  (define (read-word port)
    (skip-whitespace port)
    (let ((line (read-delimited "\t" port)))
      (if (eof-object? line)
          #f
          (map! (λ (x) (string-split x #\space))
                (string-split line #\newline)))))
  (define count (make-hash-table 100000))
  (define (add-word next)
    (unless (string-null? next)
      (hash-set! count next
                 (1+ (hash-ref count next 0)))))
  (let loop ((next (read-word port)))
    (when next
      (for-each (lambda (wl) (for-each add-word wl)) next)
      (loop (read-word port))))
  (sort! ;; destructive sort to save memory
   (hash-map->list cons count)
   count-or-unicode>?))

(for-each
 (lambda (x) (format #t "~a\t~a\n" (car x) (cdr x)))
 (count-words (current-input-port)))
