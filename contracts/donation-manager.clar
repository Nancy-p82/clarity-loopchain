;; Donation Manager Contract

;; Constants
(define-constant err-invalid-amount (err u200))
(define-constant err-unauthorized (err u201))

;; Data structures
(define-map donations
  uint
  {
    donor: principal,
    recipient: principal,
    amount: uint,
    timestamp: uint
  }
)

(define-data-var donation-counter uint u0)

;; Public functions
(define-public (donate (nonprofit principal) (amount uint))
  (let ((donation-id (var-get donation-counter)))
    (if (> amount u0)
      (begin
        (try! (stx-transfer? amount tx-sender nonprofit))
        (var-set donation-counter (+ donation-id u1))
        (ok (map-set donations donation-id {
          donor: tx-sender,
          recipient: nonprofit,
          amount: amount,
          timestamp: block-height
        })))
      err-invalid-amount
    )
  )
)

;; Read only functions
(define-read-only (get-donation (id uint))
  (ok (map-get? donations id))
)
