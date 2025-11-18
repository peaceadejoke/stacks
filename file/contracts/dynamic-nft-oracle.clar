;; contracts/dynamic-nft-oracle.clar
;; Oracle-style contract that updates the NFT dynamic state

(define-data-var admin principal tx-sender)

;; Store latest external value (e.g., price, level, index)
(define-data-var latest-value uint u0)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u200))
    (var-set admin new-admin)
    (ok true)
  )
)

;; Update the oracle value (admin only)
(define-public (update-value (new-value uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u201))
    (var-set latest-value new-value)
    (ok new-value)
  )
)

;; Push the latest oracle value into the NFT contract
(define-public (push-to-nft)
  (let (
        (value (var-get latest-value))
      )
    (ok (contract-call? .dynamic-nft update-state value))
  )
)

;; Read-only: return the current oracle value
(define-read-only (get-latest-value)
  (ok (var-get latest-value))
)
