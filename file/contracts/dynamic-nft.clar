;; contracts/dynamic-nft.clar
(define-non-fungible-token dynamic-nft uint)

;; Admin of the contract (set at deploy time or via set-admin)
(define-data-var admin principal tx-sender)

;; External state that controls metadata (0 = default, 1 = upgraded, ...)
(define-data-var external-state uint u0)

;; Mapping from state -> metadata URI buffer
(define-map state-uri-map
  { state: uint }
  { uri: (buff 200) }
)

;; Optional base URI fallback (buff as hex)
(define-data-var base-uri (buff 200) 0x64656d6f2f) ;; "demo/"

;; ---------- Admin helpers ----------

;; Allows current admin to set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (var-set admin new-admin)
    (ok true)
  )
)

;; Register a URI for a specific state (admin only)
(define-public (set-uri (state uint) (uri (buff 200)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u101))
    (map-set state-uri-map { state: state } { uri: uri })
    (ok true)
  )
)

;; ---------- NFT actions ----------

;; Mint an NFT (admin only)
(define-public (mint (id uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u102))
    (nft-mint? dynamic-nft id recipient)
  )
)

;; Update the dynamic state affecting metadata (admin only)
(define-public (update-state (new-state uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u103))
    (var-set external-state new-state)
    (ok new-state)
  )
)

;; ---------- Read-only helpers ----------

;; Return the active URI for a given token id. Uses state -> uri map,
;; falling back to base-uri if no entry found.
(define-read-only (get-token-uri (id uint))
  (let
    (
      (state (var-get external-state))
      (entry (map-get? state-uri-map { state: state }))
    )
    (match entry
      entry-data (ok (get uri entry-data))
      ;; fallback to base-uri if no mapping
      (ok (var-get base-uri))
    )
  )
)
