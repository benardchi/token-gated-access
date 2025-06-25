;; --------------------------------------------------
;; Contract: token-gated-access (Dynamic Version)
;; Description: Access control based on SIP-010 token ownership
;; Author: [Your Name]
;; --------------------------------------------------

(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_ADMIN (err u403))
(define-constant ERR_INVALID_TOKEN (err u410))

(define-data-var token-threshold uint u1)
(define-constant contract-owner tx-sender) ;; locked at deploy

;; SIP-010 trait interface
(define-trait sip010-ft-standard
  (
    (get-balance (principal) (response uint uint))
    (get-decimals () (response uint uint))
  )
)

;; === Admin: Set threshold ===
(define-public (set-token-threshold (threshold uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) ERR_NOT_ADMIN)
    (var-set token-threshold threshold)
    (ok true)
  )
)

;; === Public: Check access with token contract as parameter ===
(define-public (check-access (token <sip010-ft-standard>) (user principal))
  (let (
        (threshold (var-get token-threshold))
       )
    (match (contract-call? token get-balance user)
      response-ok (ok (>= response-ok threshold))
      response-err ERR_INVALID_TOKEN
    )
  )
)

;; === Public: Verify and emit access event ===
(define-public (verify-and-log (token <sip010-ft-standard>))
  (let (
        (threshold (var-get token-threshold))
       )
    (match (contract-call? token get-balance tx-sender)
      response-ok
        (if (>= response-ok threshold)
            (begin
              (print {event: "access-granted", user: tx-sender})
              (ok true))
            ERR_UNAUTHORIZED)
      response-err ERR_INVALID_TOKEN
    )
  )
)

;; === View current threshold ===
(define-read-only (get-access-config)
  {
    threshold: (var-get token-threshold)
  }
)