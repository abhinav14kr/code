-- Businesses that post shifts
CREATE TABLE businesses (
  business_id      BIGINT PRIMARY KEY,
  name             TEXT,
  city             TEXT,
  vertical         TEXT,      -- e.g., warehouse, events, manufacturing
  created_at       TIMESTAMP
);

-- Workers who pick up shifts
CREATE TABLE workers (
  worker_id        BIGINT PRIMARY KEY,
  first_name       TEXT,
  last_name        TEXT,
  city             TEXT,
  signup_at        TIMESTAMP
);

-- Shifts posted by businesses
CREATE TABLE shifts (
  shift_id         BIGINT PRIMARY KEY,
  business_id      BIGINT REFERENCES businesses(business_id),
  role             TEXT,      -- e.g., picker, loader
  city             TEXT,
  pay_rate_usd     NUMERIC(10,2),
  posted_at        TIMESTAMP,
  filled_at        TIMESTAMP, -- NULL if never filled
  start_at         TIMESTAMP,
  end_at           TIMESTAMP,
  cancelled_flag   BOOLEAN DEFAULT FALSE
);

-- Which worker was scheduled & whether they showed
CREATE TABLE attendance (
  shift_id         BIGINT REFERENCES shifts(shift_id),
  worker_id        BIGINT REFERENCES workers(worker_id),
  scheduled_flag   BOOLEAN,           -- worker was assigned
  showed_flag      BOOLEAN,           -- worker actually showed
  checkin_at       TIMESTAMP,
  PRIMARY KEY (shift_id, worker_id)
);

-- Payments to workers per shift
CREATE TABLE payments (
  payment_id       BIGINT PRIMARY KEY,
  shift_id         BIGINT REFERENCES shifts(shift_id),
  worker_id        BIGINT REFERENCES workers(worker_id),
  gross_pay_usd    NUMERIC(10,2),
  paid_at          TIMESTAMP
);
