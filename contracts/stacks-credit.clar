;; StacksLend: Decentralized Credit Protocol for Bitcoin DeFi
;;
;; A merit-based lending protocol that bridges traditional credit systems 
;; with Bitcoin DeFi through Stacks Layer 2. Features include:
;;
;; - Dynamic credit scoring based on on-chain behavior
;; - Risk-adjusted collateral requirements (50-100%)
;; - Variable interest rates (5-10% based on credit score)
;; - Transparent loan history and credit reporting
;; - Maximum loan duration of 1 year (52,560 blocks)
;; - Up to 5 active loans per user
;;
;; Security measures:
;; - Required minimum credit score of 70
;; - Collateral locked in contract
;; - Automatic credit score adjustments
;; - Owner-only default management

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-BALANCE (err u2))
(define-constant ERR-INVALID-AMOUNT (err u3))
(define-constant ERR-LOAN-NOT-FOUND (err u4))
(define-constant ERR-LOAN-DEFAULTED (err u5))
(define-constant ERR-INSUFFICIENT-SCORE (err u6))
(define-constant ERR-ACTIVE-LOAN (err u7))
(define-constant ERR-NOT-DUE (err u8))
(define-constant ERR-INVALID-DURATION (err u9))
(define-constant ERR-INVALID-LOAN-ID (err u10))

;; Credit score thresholds
(define-constant MIN-SCORE u50)
(define-constant MAX-SCORE u100)
(define-constant MIN-LOAN-SCORE u70)

;; Data Maps
(define-map UserScores
  { user: principal }
  {
    score: uint,
    total-borrowed: uint,
    total-repaid: uint,
    loans-taken: uint,
    loans-repaid: uint,
    last-update: uint,
  }
)

(define-map Loans
  { loan-id: uint }
  {
    borrower: principal,
    amount: uint,
    collateral: uint,
    due-height: uint,
    interest-rate: uint,
    is-active: bool,
    is-defaulted: bool,
    repaid-amount: uint,
  }
)

(define-map UserLoans
  { user: principal }
  { active-loans: (list 20 uint) }
)

;; Variables
(define-data-var next-loan-id uint u0)
(define-data-var total-stx-locked uint u0)

;; Public Functions

;; Initialize a new user's credit score
;; This must be called before a user can request any loans
(define-public (initialize-score)
  (let ((sender tx-sender))
    (asserts! (is-none (map-get? UserScores { user: sender })) ERR-UNAUTHORIZED)
    (ok (map-set UserScores { user: sender } {
      score: MIN-SCORE,
      total-borrowed: u0,
      total-repaid: u0,
      loans-taken: u0,
      loans-repaid: u0,
      last-update: stacks-block-height,
    }))
  )
)