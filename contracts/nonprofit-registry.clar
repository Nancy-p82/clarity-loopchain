;; Nonprofit Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-found (err u102))

;; Data structures
(define-map nonprofits
  principal
  {
    name: (string-utf8 256),
    description: (string-utf8 1024),
    verified: bool,
    registration-date: uint
  }
)

;; Public functions
(define-public (register-nonprofit (name (string-utf8 256)) (description (string-utf8 1024)))
  (let ((nonprofit-data {
    name: name,
    description: description,
    verified: false,
    registration-date: block-height
  }))
    (if (is-none (map-get? nonprofits tx-sender))
      (ok (map-set nonprofits tx-sender nonprofit-data))
      err-already-registered
    )
  )
)

(define-public (verify-nonprofit (nonprofit principal))
  (if (is-eq tx-sender contract-owner)
    (match (map-get? nonprofits nonprofit)
      nonprofit-data (ok (map-set nonprofits 
        nonprofit
        (merge nonprofit-data { verified: true })))
      err-not-found
    )
    err-not-owner
  )
)

;; Read only functions
(define-read-only (get-nonprofit (nonprofit principal))
  (ok (map-get? nonprofits nonprofit))
)
