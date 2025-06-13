-- Scenario: Returning the most recent event for each transaction

select evts.id, evts.user_id, evts.transaction_id, evts.result, csr.created_at, csr.updated_at 
from (
    select *, row_number() over (partition by transaction_id order by created_at desc) as rn
    from events
) as evts
where rn = 1

-- Sample events table

-- | id  | user_id | transaction_id | result   | created_at          | updated_at          |
-- |-----|---------|----------------|----------|---------------------|---------------------|
-- | 1   | 101     | 1001           | Success  | 2025-06-13 10:00:00 | 2025-06-13 12:00:00 |
-- | 2   | 102     | 1002           | Failed   | 2025-06-13 11:00:00 | 2025-06-13 13:00:00 |
-- | 3   | 103     | 1003           | Pending  | 2025-06-13 09:30:00 | 2025-06-13 11:30:00 |
-- | 4   | 101     | 1001           | Success  | 2025-06-13 14:00:00 | 2025-06-13 15:00:00 |
-- | 5   | 104     | 1004           | Success  | 2025-06-13 08:00:00 | 2025-06-13 10:00:00 |

-- Result

-- | id | user_id | transaction_id | result  | created_at          | updated_at          |
-- |----|---------|----------------|---------|---------------------|---------------------|
-- | 4  | 101     | 1001           | Success | 2025-06-13 14:00:00 | 2025-06-13 15:00:00 |
-- | 2  | 102     | 1002           | Failed  | 2025-06-13 11:00:00 | 2025-06-13 13:00:00 |
-- | 3  | 103     | 1003           | Pending | 2025-06-13 09:30:00 | 2025-06-13 11:30:00 |
-- | 5  | 104     | 1004           | Success | 2025-06-13 08:00:00 | 2025-06-13 10:00:00 |

-- Scenario: Returning all events with a row number indicating the most recent event per transaction

select evts.id, evts.user_id, evts.transaction_id, evts.result, csr.created_at, csr.updated_at, rn 
from (
    select *, row_number() over (partition by transaction_id order by created_at desc) as rn
    from events
) as evts

-- | id | user_id | transaction_id | result  | created_at          | updated_at          | rn |
-- |----|---------|----------------|---------|---------------------|---------------------|----|
-- | 4  | 101     | 1001           | Success | 2025-06-13 14:00:00 | 2025-06-13 15:00:00 | 1  |
-- | 1  | 101     | 1001           | Success | 2025-06-13 10:00:00 | 2025-06-13 12:00:00 | 2  |
-- | 2  | 102     | 1002           | Failed  | 2025-06-13 11:00:00 | 2025-06-13 13:00:00 | 1  |
-- | 3  | 103     | 1003           | Pending | 2025-06-13 09:30:00 | 2025-06-13 11:30:00 | 1  |
-- | 5  | 104     | 1004           | Success | 2025-06-13 08:00:00 | 2025-06-13 10:00:00 | 1  |
