;; contracts/dynamic-nft-metadata.clar
;; NFT Metadata Registry for Dynamic NFT Project
;; Stores additional metadata for each NFT with access control

(define-data-var admin principal tx-sender)

;; Map NFT ID -> metadata { title, description, image-url }
(define-map nft-metadata
  { id: uint }
  { title: (buff 100), description: (buff 250), image-url: (buff 200) }
)

;; ---------- Admin Management ----------

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u300))
    (var-set admin new-admin)
    (ok true)
  )
)

;; ---------- Metadata Management ----------

;; Add or update metadata (admin only)
(define-public (set-metadata (id uint) (title (buff 100)) (description (buff 250)) (image-url (buff 200)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u301))
    ;; Validate that buffers are not empty
    (asserts! (> (len title) u0) (err u302))
    (asserts! (> (len description) u0) (err u303))
    (asserts! (> (len image-url) u0) (err u304))
    (map-set nft-metadata { id: id } { title: title, description: description, image-url: image-url })
    (ok true)
  )
)

;; Read-only: get metadata for NFT ID
(define-read-only (get-metadata (id uint))
  (let ((entry (map-get? nft-metadata { id: id })))
    (match entry
      entry-data (ok entry-data)
      (err u305)
    )
  )
)
