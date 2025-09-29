/// 입장권 상태
enum PassStatus { waiting, entering, entered, reservation }

/// 예약 카드 상태
enum ReservationStatus { pendingApproval, confirmed, canceled }

/// 이용 내역 리뷰 상태
enum HistoryClubCardReviewStatus { reviewed, notReviewed, expired }
