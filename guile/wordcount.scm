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
        (ice-9 hash-table))

(define (count-or-unicode>? a b)
  (let ((Na (car a))(Nb (car b)))
    (or (> Na Nb)
        (and (= Na Nb)
             (string<? (cdr a) (cdr b))))))

(define (skip-whitespace port)
  (let ([ch (peek-char port)])
    (or (eof-object? ch) (not (char-whitespace? ch))
        (begin (read-char port)
               (skip-whitespace port)))))

(define (count-words port)
  (define delimiters " \t\n")
  (define buf (make-string 10000))
  (define (read-word port)
    (skip-whitespace port)
    (let ((res (%read-delimited! delimiters buf #t port)))
      (or (and (eof-object? (car res))
               (car res))
          (substring buf 0 (cdr res)))))
  (define count (make-hash-table 100000))
  (define (add-word next)
    (hash-set! count next
               (1+ (hash-ref count next 0))))
  (let loop ((next (read-word port)))
    (unless (eof-object? next)
      (unless (string-null? next)
        (add-word next))
      (loop (read-word port))))
  (sort! ;; destructive sort to save memory
   (hash-map->list (lambda (key val) (cons val key)) count)
   count-or-unicode>?))

(for-each
 (lambda (x) (format #t "~a\t~a\n" (cdr x) (car x)))
 (count-words (current-input-port)))
