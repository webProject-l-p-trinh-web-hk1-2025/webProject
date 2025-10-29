-- Add cancel_note column to orders table
ALTER TABLE orders ADD COLUMN IF NOT EXISTS cancel_note VARCHAR(1000);

-- Add comment to explain the column
COMMENT ON COLUMN orders.cancel_note IS 'Lý do hủy đơn hàng từ seller';
