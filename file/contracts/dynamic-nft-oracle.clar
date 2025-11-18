;; contracts/dynamic-nft-oracle.clar
;; Phase 3 Oracle: access control, history logging, safe cross-contract calls

(define-data-var admin principal tx-sender)

;; Latest external value stored in oracle
(define-data-var latest-value uint u0)

;; Authorized callers map: key {addr: principal} -> {allowed: bool}
(define-map authorized-map
  { addr: principal }
  { allowed: bool }
)

;; History entries map: key { index: uint } -> { value: uint, block-height: uint, caller: principal }
(define-map history-map
  { index: uint }
  { value: uint, block-height: uint, caller: principal }
)

;; Counter for history entries (next index to write)
(define-data-var history-count uint u0)

;; ---------- Admin management ----------

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u200))
    (var-set admin new-admin)
    (ok true)
  )
)

;; Add an authorized caller (admin only)
(define-public (add-authorized (who principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u201))
    (map-set authorized-map { addr: who } { allowed: true })
    (ok true)
  )
)

;; Remove an authorized caller (admin only)
(define-public (remove-authorized (who principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u202))
    (map-delete authorized-map { addr: who })
    (ok true)
  )
)

;; ---------- Oracle internal updates ----------

;; Admin-only update of internal value
(define-public (update-value (new-value uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u203))
    (var-set latest-value new-value)
    (ok new-value)
  )
)

;; Read-only: is an address authorized?
(define-read-only (is-authorized (who principal))
  (let ((entry (map-get? authorized-map { addr: who })))
    (match entry
      entry-data (ok (get allowed entry-data))
      (ok false)
    )
  )
)

;; Read-only: get latest internal value
(define-read-only (get-latest-value)
  (ok (var-get latest-value))
)

;; Read-only: get history count
(define-read-only (get-history-count)
  (ok (var-get history-count))
)

;; Read-only: get history by index
(define-read-only (get-history-by-index (idx uint))
  (let ((entry (map-get? history-map { index: idx })))
    (match entry
      entry-data (ok entry-data)
      (err u210)
    )
  )
)

;; ---------- Push to NFT with safety and logging ----------

;; Authorized callers only. Calls dynamic-nft.update-state and records history only on success.
(define-public (push-to-nft)
  (let ((auth-entry (map-get? authorized-map { addr: tx-sender }))
        (value (var-get latest-value)))
    ;; Ensure caller is authorized
    (match auth-entry
      entry-data
        (let ((allowed (get allowed entry-data)))
          (if (is-eq allowed true)
            ;; proceed
            (let ((call-res (contract-call? .dynamic-nft update-state value)))
              ;; handle the result of the contract call
              (match call-res
                call-ok
                  ;; record history only after successful on-chain update
                  (let ((idx (var-get history-count))
                        (height block-height)) ;; built-in current block height
                    (map-set history-map
                      { index: idx }
                      { value: value, block-height: height, caller: tx-sender }
                    )
                    (var-set history-count (+ idx u1))
                    (ok call-ok)
                  )
                call-err
                  ;; Bubble up the error from the NFT contract
                  (err call-err)
              )
            )
            ;; caller is not allowed
            (err u204)
          )
        )
      ;; no map entry -> not authorized
      (err u204)
    )
  )
)
