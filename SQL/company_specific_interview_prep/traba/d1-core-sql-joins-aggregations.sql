# 🎯 Traba SQL Interview - Complete Answer Key & Explanations

## Problem 1: Supply-Demand Balance Analysis (Easy)

```sql
WITH supply AS (
    SELECT location, COUNT(*) as available_workers
    FROM workers 
    WHERE availability_status = 'available'
    GROUP BY location
),
demand AS (
    SELECT b.location, COUNT(*) as open_jobs
    FROM job_posts jp
    JOIN businesses b ON jp.business_id = b.business_id
    WHERE jp.status = 'open' 
    AND jp.start_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY b.location
)
SELECT 
    COALESCE(s.location, d.location) as location,
    COALESCE(s.available_workers, 0) as available_workers,
    COALESCE(d.open_jobs, 0) as open_jobs,
    CASE 
        WHEN d.open_jobs > 0 THEN ROUND(s.available_workers::numeric / d.open_jobs, 2)
        ELSE NULL 
    END as supply_demand_ratio
FROM supply s
FULL OUTER JOIN demand d ON s.location = d.location
ORDER BY supply_demand_ratio DESC NULLS LAST;
```

## ---

### 📝 Key Concepts Explained:

* **CTEs for clarity:** Separate supply and demand calculations make the logic clear
* **FULL OUTER JOIN:** Captures locations with only supply OR only demand
* **COALESCE:** Handles NULL values gracefully
* **Business Logic:** Ratio > 1 means oversupply, < 1 means undersupply
* **Time filtering:** Past 30 days ensures current market conditions

### 💼 Business Impact:

This query powers real-time marketplace health dashboards, helping Traba identify markets needing more worker recruitment or business development.

---

## Problem 2: Worker Engagement & Churn Analysis (Medium)

```sql
WITH worker_applications AS (
    SELECT 
        w.worker_id,
        w.name,
        w.signup_date,
        COUNT(a.application_id) as total_applications,
        COUNT(CASE WHEN a.status = 'accepted' THEN 1 END) as accepted_applications,
        MAX(a.applied_at) as last_application_date,
        AVG(EXTRACT(days FROM (a.applied_at - LAG(a.applied_at) OVER (PARTITION BY w.worker_id ORDER BY a.applied_at)))) as avg_days_between_applications
    FROM workers w
    LEFT JOIN applications a ON w.worker_id = a.worker_id 
        AND a.applied_at >= CURRENT_DATE - INTERVAL '3 months'
    GROUP BY w.worker_id, w.name, w.signup_date
)
SELECT 
    worker_id,
    name,
    total_applications,
    CASE 
        WHEN total_applications > 0 THEN ROUND((accepted_applications::numeric / total_applications) * 100, 1)
        ELSE 0 
    END as acceptance_rate_pct,
    ROUND(avg_days_between_applications, 1) as avg_days_between_applications,
    CASE 
        WHEN last_application_date < CURRENT_DATE - INTERVAL '14 days' OR last_application_date IS NULL 
        THEN 'at_risk'
        ELSE 'active' 
    END as engagement_status,
    EXTRACT(days FROM (CURRENT_DATE - last_application_date)) as days_since_last_application
FROM worker_applications
ORDER BY total_applications DESC, acceptance_rate_pct DESC;
```

## ---

### 📝 Key Concepts Explained:

* **LAG() with PARTITION BY:** Calculates time between successive applications for each worker
* **Conditional aggregation:** COUNT(CASE WHEN...) counts specific statuses
* **Risk segmentation:** 14-day threshold for identifying disengaged workers
* **LEFT JOIN:** Preserves all workers, even those with no applications

### 💼 Business Impact:

Enables proactive worker retention campaigns and helps optimize the matching algorithm by understanding worker behavior patterns.

---

## Problem 3: Revenue Forecasting & Trending (Medium)

```sql
WITH weekly_revenue AS (
    SELECT 
        DATE_TRUNC('week', s.start_time) as week_start,
        SUM(s.hours_worked * s.hourly_rate * 0.15) as weekly_commission_revenue
    FROM shifts s
    WHERE s.status = 'completed'
    GROUP BY DATE_TRUNC('week', s.start_time)
),
revenue_with_metrics AS (
    SELECT 
        week_start,
        weekly_commission_revenue,
        AVG(weekly_commission_revenue) OVER (
            ORDER BY week_start 
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) as four_week_rolling_avg,
        LAG(weekly_commission_revenue) OVER (ORDER BY week_start) as prev_week_revenue,
        SUM(weekly_commission_revenue) OVER (ORDER BY week_start) as cumulative_revenue
    FROM weekly_revenue
)
SELECT 
    week_start,
    ROUND(weekly_commission_revenue, 2) as weekly_revenue,
    ROUND(four_week_rolling_avg, 2) as four_week_rolling_avg,
    CASE 
        WHEN prev_week_revenue > 0 THEN 
            ROUND(((weekly_commission_revenue - prev_week_revenue) / prev_week_revenue * 100), 1)
        ELSE NULL 
    END as wow_growth_rate_pct,
    ROUND(cumulative_revenue, 2) as cumulative_revenue
FROM revenue_with_metrics
ORDER BY week_start DESC
LIMIT 12; -- Last 12 weeks
```

## ---

### 📝 Key Concepts Explained:

* **DATE\_TRUNC:** Groups data by week for trend analysis
* **Commission calculation:** 15% of worker earnings = Traba's revenue
* **Rolling average:** Smooths weekly volatility to show trends
* **Growth rate calculation:** Week-over-week percentage change
* **Multiple window functions:** Each serves a different analytical purpose

### 💼 Business Impact:

Powers executive dashboards and financial forecasting models that inform strategic decisions about growth investments and market expansion.

---

## Problem 4: Operational Efficiency & Capacity Optimization (Hard)

```sql
WITH hourly_demand AS (
    SELECT 
        EXTRACT(dow FROM start_time) as day_of_week,
        EXTRACT(hour FROM start_time) as hour_of_day,
        COUNT(*) as shift_requests,
        SUM(EXTRACT(hours FROM (end_time - start_time))) as total_hours_demanded
    FROM shifts 
    WHERE start_time >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY EXTRACT(dow FROM start_time), EXTRACT(hour FROM start_time)
),
hourly_supply AS (
    SELECT 
        dow.day_of_week,
        hour_series.hour_of_day,
        COUNT(w.worker_id) as available_workers,
        COUNT(w.worker_id) * 1.0 as potential_worker_hours
    FROM (SELECT generate_series(0, 6) as day_of_week) dow
    CROSS JOIN (SELECT generate_series(6, 22) as hour_of_day) hour_series
    CROSS JOIN workers w
    WHERE w.availability_status = 'available'
    GROUP BY dow.day_of_week, hour_series.hour_of_day
),
capacity_analysis AS (
    SELECT 
        d.day_of_week,
        d.hour_of_day,
        CASE d.day_of_week 
            WHEN 0 THEN 'Sunday' WHEN 1 THEN 'Monday' WHEN 2 THEN 'Tuesday'
            WHEN 3 THEN 'Wednesday' WHEN 4 THEN 'Thursday' WHEN 5 THEN 'Friday'
            WHEN 6 THEN 'Saturday' 
        END as day_name,
        COALESCE(d.shift_requests, 0) as demand_shifts,
        COALESCE(d.total_hours_demanded, 0) as demand_hours,
        COALESCE(s.available_workers, 0) as supply_workers,
        COALESCE(s.potential_worker_hours, 0) as supply_hours,
        CASE 
            WHEN s.potential_worker_hours > 0 THEN 
                ROUND((d.total_hours_demanded / s.potential_worker_hours * 100), 1)
            ELSE 0 
        END as utilization_rate_pct,
        GREATEST(0, COALESCE(d.total_hours_demanded, 0) - COALESCE(s.potential_worker_hours, 0)) as capacity_shortage
    FROM hourly_demand d
    FULL OUTER JOIN hourly_supply s ON d.day_of_week = s.day_of_week AND d.hour_of_day = s.hour_of_day
)
SELECT 
    day_name,
    hour_of_day,
    demand_shifts,
    demand_hours,
    supply_workers,
    supply_hours,
    utilization_rate_pct,
    capacity_shortage,
    CASE 
        WHEN utilization_rate_pct > 90 THEN 'High Utilization'
        WHEN utilization_rate_pct > 70 THEN 'Medium Utilization'  
        ELSE 'Low Utilization'
    END as utilization_category,
    ROW_NUMBER() OVER (ORDER BY capacity_shortage DESC) as capacity_shortage_rank
FROM capacity_analysis
WHERE demand_hours > 0
ORDER BY capacity_shortage DESC, utilization_rate_pct DESC
LIMIT 20;
```

## ---

### 📝 Key Concepts Explained:

* **Time dimension analysis:** EXTRACT() for day of week and hour patterns
* **CROSS JOIN:** Creates all possible time combinations for complete analysis
* **Capacity calculations:** Supply vs demand mathematics
* **Business hours focus:** 6 AM to 10 PM operational window
* **GREATEST/LEAST:** Handles edge cases in calculations

### 💼 Business Impact:

Identifies when Traba needs to recruit more workers in specific time slots and locations, directly improving customer satisfaction and marketplace efficiency.

---

## Problem 5: Business Performance Dashboard Metrics (Hard)

```sql
WITH business_activity AS (
    SELECT 
        b.business_id,
        b.company_name,
        b.industry,
        COUNT(DISTINCT jp.job_id) as total_jobs_posted,
        COUNT(DISTINCT CASE WHEN jp.start_date >= CURRENT_DATE - INTERVAL '30 days' THEN jp.job_id END) as jobs_last_30_days,
        AVG(EXTRACT(days FROM (
            SELECT MIN(a.applied_at) 
            FROM applications a 
            WHERE a.job_id = jp.job_id AND a.status = 'accepted'
        ) - jp.start_date)) as avg_time_to_fill_days,
        COUNT(DISTINCT DATE_TRUNC('month', jp.start_date)) as active_months
    FROM businesses b
    LEFT JOIN job_posts jp ON b.business_id = jp.business_id
    WHERE jp.start_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY b.business_id, b.company_name, b.industry
),
satisfaction_scores AS (
    SELECT 
        b.business_id,
        AVG(CASE WHEN r.rater_type = 'business' THEN r.rating END) as avg_business_rating,
        COUNT(CASE WHEN r.rater_type = 'business' THEN 1 END) as business_ratings_count
    FROM businesses b
    JOIN job_posts jp ON b.business_id = jp.business_id
    JOIN shifts s ON jp.job_id = s.job_id
    LEFT JOIN ratings r ON s.shift_id = r.shift_id
    WHERE s.start_time >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY b.business_id
),
retention_metrics AS (
    SELECT 
        business_id,
        CASE 
            WHEN COUNT(DISTINCT DATE_TRUNC('month', jp.start_date)) >= 2 THEN 
                COUNT(DISTINCT DATE_TRUNC('month', jp.start_date))::numeric / 
                GREATEST(1, EXTRACT(months FROM (MAX(jp.start_date) - MIN(jp.start_date))))
            ELSE 0
        END as retention_score
    FROM job_posts jp
    WHERE jp.start_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY business_id
),
business_scorecard AS (
    SELECT 
        ba.business_id,
        ba.company_name,
        ba.industry,
        ba.jobs_last_30_days,
        CASE WHEN ba.jobs_last_30_days > 0 THEN 'Active' ELSE 'Inactive' END as status,
        ROUND(ba.avg_time_to_fill_days, 1) as avg_time_to_fill_days,
        ROUND(COALESCE(ss.avg_business_rating, 0), 2) as avg_satisfaction_rating,
        ss.business_ratings_count,
        ROUND(COALESCE(rm.retention_score, 0), 2) as retention_score,
        -- Health score calculation (weighted)
        ROUND(
            (LEAST(ba.jobs_last_30_days * 10, 50) * 0.3) + -- Activity weight 30%
            (CASE WHEN ba.avg_time_to_fill_days IS NOT NULL THEN GREATEST(0, 100 - ba.avg_time_to_fill_days * 5) ELSE 0 END * 0.25) + -- Efficiency weight 25%
            (COALESCE(ss.avg_business_rating, 0) * 20 * 0.25) + -- Satisfaction weight 25%
            (COALESCE(rm.retention_score, 0) * 100 * 0.2) -- Retention weight 20%
        , 1) as health_score
    FROM business_activity ba
    LEFT JOIN satisfaction_scores ss ON ba.business_id = ss.business_id  
    LEFT JOIN retention_metrics rm ON ba.business_id = rm.business_id
)
SELECT 
    company_name,
    industry,
    status,
    jobs_last_30_days,
    avg_time_to_fill_days,
    avg_satisfaction_rating,
    business_ratings_count,
    retention_score,
    health_score,
    ROW_NUMBER() OVER (ORDER BY health_score DESC) as health_rank,
    CASE 
        WHEN health_score >= 80 THEN 'Excellent'
        WHEN health_score >= 60 THEN 'Good'
        WHEN health_score >= 40 THEN 'Fair'
        ELSE 'Poor'
    END as health_category
FROM business_scorecard
WHERE jobs_last_30_days > 0 OR health_score > 0
ORDER BY health_score DESC;
```

## ---

### 📝 Key Concepts Explained:

* **Multi-CTE structure:** Breaks complex calculation into logical components
* **Weighted scoring:** Different metrics have different importance levels
* **Correlated subquery:** Calculates time-to-fill accurately
* **Health categorization:** Converts numeric scores into actionable business categories
* **ROW\_NUMBER() for ranking:** Creates prioritized business list

### 💼 Business Impact:

Creates actionable customer health scores enabling account management to focus on at-risk customers and identify expansion opportunities.

---

## Problem 6: Worker Success Prediction Model (Hard)

```sql
WITH worker_performance AS (
    SELECT 
        w.worker_id,
        w.name,
        w.signup_date,
        w.location,
        EXTRACT(days FROM (CURRENT_DATE - w.signup_date)) as days_since_signup,
        COUNT(s.shift_id) as total_shifts,
        COUNT(CASE WHEN s.status = 'completed' THEN 1 END) as completed_shifts,
        CASE 
            WHEN COUNT(s.shift_id) > 0 THEN 
                ROUND(COUNT(CASE WHEN s.status = 'completed' THEN 1 END)::numeric / COUNT(s.shift_id) * 100, 1)
            ELSE 0 
        END as completion_rate_pct,
        AVG(r.rating) as avg_rating,
        STDDEV(r.rating) as rating_consistency,
        COUNT(r.rating) as total_ratings,
        COUNT(DISTINCT DATE_TRUNC('month', s.start_time)) as active_months,
        MAX(s.start_time) as last_shift_date
    FROM workers w
    LEFT JOIN shifts s ON w.worker_id = s.worker_id
    LEFT JOIN ratings r ON s.shift_id = r.shift_id AND r.rater_type = 'business'
    WHERE w.signup_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY w.worker_id, w.name, w.signup_date, w.location
),
rating_trends AS (
    SELECT 
        w.worker_id,
        AVG(CASE WHEN s.start_time <= w.signup_date + INTERVAL '60 days' THEN r.rating END) as early_avg_rating,
        AVG(CASE WHEN s.start_time >= CURRENT_DATE - INTERVAL '60 days' THEN r.rating END) as recent_avg_rating,
        CASE 
            WHEN COUNT(r.rating) >= 5 THEN
                (COUNT(*) * SUM(EXTRACT(days FROM (s.start_time - w.signup_date)) * r.rating) - 
                 SUM(EXTRACT(days FROM (s.start_time - w.signup_date))) * SUM(r.rating)) /
                NULLIF(COUNT(*) * SUM(POWER(EXTRACT(days FROM (s.start_time - w.signup_date)), 2)) - 
                       POWER(SUM(EXTRACT(days FROM (s.start_time - w.signup_date))), 2), 0)
            ELSE 0
        END as rating_trend_slope
    FROM workers w
    JOIN shifts s ON w.worker_id = s.worker_id
    JOIN ratings r ON s.shift_id = r.shift_id AND r.rater_type = 'business'
    WHERE s.status = 'completed'
    GROUP BY w.worker_id
),
success_scores AS (
    SELECT 
        wp.*,
        COALESCE(rt.early_avg_rating, 0) as early_avg_rating,
        COALESCE(rt.recent_avg_rating, 0) as recent_avg_rating,
        COALESCE(rt.rating_trend_slope, 0) as rating_improvement_trend,
        -- Success score calculation (weighted components)
        ROUND(
            (wp.completion_rate_pct * 0.25) + -- 25% weight on completion
            (COALESCE(wp.avg_rating, 0) * 20 * 0.25) + -- 25% weight on rating (scale to 100)
            (CASE WHEN wp.rating_consistency IS NOT NULL 
                  THEN GREATEST(0, 100 - wp.rating_consistency * 25) 
                  ELSE 50 END * 0.15) + -- 15% weight on consistency
            (LEAST(wp.active_months * 8.33, 50) * 0.20) + -- 20% weight on retention (6 months = 50 points)
            (CASE WHEN rt.rating_trend_slope > 0 THEN LEAST(rt.rating_trend_slope * 1000, 25) ELSE 0 END * 0.15) -- 15% weight on improvement
        , 1) as success_score
    FROM worker_performance wp
    LEFT JOIN rating_trends rt ON wp.worker_id = rt.worker_id
),
performance_segments AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY success_score DESC) as performance_quartile,
        CASE 
            WHEN success_score >= 80 THEN 'High Performer'
            WHEN success_score >= 60 THEN 'Good Performer'
            WHEN success_score >= 40 THEN 'Average Performer'
            ELSE 'Low Performer'
        END as performance_category,
        CASE 
            WHEN last_shift_date < CURRENT_DATE - INTERVAL '30 days' THEN 'Churn Risk'
            WHEN completion_rate_pct < 80 THEN 'Quality Risk'
            WHEN avg_rating < 3.5 THEN 'Rating Risk'
            ELSE 'Good Standing'
        END as risk_flag
    FROM success_scores
)
SELECT 
    name,
    location,
    days_since_signup,
    total_shifts,
    completion_rate_pct,
    ROUND(avg_rating, 2) as avg_rating,
    ROUND(rating_consistency, 2) as rating_std_dev,
    active_months,
    ROUND(rating_improvement_trend, 4) as rating_trend,
    success_score,
    performance_quartile,
    performance_category,
    risk_flag,
    ROW_NUMBER() OVER (ORDER BY success_score DESC) as success_rank
FROM performance_segments
WHERE total_shifts > 0
ORDER BY success_score DESC
LIMIT 50;
```

## ---

### 📝 Key Concepts Explained:

* **Feature engineering:** Creates predictive variables from raw data
* **Linear regression approximation:** Calculates rating improvement trend
* **Composite scoring:** Combines multiple metrics into single success score
* **Statistical functions:** STDDEV for consistency measurement
* **Risk segmentation:** Identifies different types of worker risks

### 💼 Business Impact:

Enables ML model development, improves worker-job matching algorithms, and helps identify high-value workers for retention programs.

---

## Problem 7: Market Expansion Analysis (Expert)

```sql
WITH market_metrics AS (
    SELECT 
        b.location,
        COUNT(DISTINCT b.business_id) as active_businesses,
        COUNT(DISTINCT jp.job_id) as total_jobs_posted,
        SUM(s.hours_worked * s.hourly_rate * 0.15) as total_revenue,
        AVG(s.hours_worked * s.hourly_rate * 0.15) as avg_revenue_per_shift,
        COUNT(DISTINCT CASE WHEN jp.start_date >= CURRENT_DATE - INTERVAL '90 days' THEN jp.job_id END) as recent_jobs,
        COUNT(DISTINCT CASE WHEN jp.start_date >= CURRENT_DATE - INTERVAL '180 days' 
                                AND jp.start_date < CURRENT_DATE - INTERVAL '90 days' THEN jp.job_id END) as prev_period_jobs,
        COUNT(DISTINCT b.industry) as industry_diversity,
        AVG(jp.hourly_rate_offered) as avg_hourly_rate
    FROM businesses b
    LEFT JOIN job_posts jp ON b.business_id = jp.business_id
    LEFT JOIN shifts s ON jp.job_id = s.job_id AND s.status = 'completed'
    WHERE jp.start_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY b.location
),
market_potential AS (
    SELECT 
        location,
        CASE 
            WHEN active_businesses > 0 THEN 
                active_businesses * (8 + (active_businesses * 0.1))
            ELSE 0 
        END as estimated_total_businesses,
        active_businesses,
        total_jobs_posted,
        total_revenue,
        CASE WHEN active_businesses > 0 THEN total_revenue / active_businesses ELSE 0 END as revenue_per_business,
        CASE 
            WHEN prev_period_jobs > 0 THEN 
                ROUND(((recent_jobs - prev_period_jobs)::numeric / prev_period_jobs * 100), 1)
            ELSE 0 
        END as growth_rate_pct,
        industry_diversity,
        avg_hourly_rate,
        recent_jobs,
        prev_period_jobs
    FROM market_metrics
),
expansion_analysis AS (
    SELECT 
        location,
        active_businesses,
        estimated_total_businesses,
        CASE 
            WHEN estimated_total_businesses > 0 THEN 
                ROUND((active_businesses::numeric / estimated_total_businesses * 100), 2)
            ELSE 0 
        END as market_penetration_pct,
        ROUND(revenue_per_business, 0) as revenue_per_business,
        growth_rate_pct,
        industry_diversity,
        ROUND(avg_hourly_rate, 2) as avg_hourly_rate,
        (estimated_total_businesses - active_businesses) * 
        CASE WHEN active_businesses > 0 THEN revenue_per_business ELSE 1000 END as addressable_market_value,
        CASE 
            WHEN estimated_total_businesses > 0 THEN 
                ROUND((100 - (active_businesses::numeric / estimated_total_businesses * 100)), 2)
            ELSE 100 
        END as expansion_opportunity_score
    FROM market_potential
),
priority_scoring AS (
    SELECT 
        *,
        ROUND(
            (expansion_opportunity_score * 0.3) + -- 30% weight on low competition
            (LEAST(growth_rate_pct, 50) * 0.25) + -- 25% weight on growth (capped at 50%)
            (CASE WHEN addressable_market_value > 0 THEN 
                 LEAST(LOG(addressable_market_value / 1000), 25) 
             ELSE 0 END * 0.25) + -- 25% weight on market size (logarithmic)
            (industry_diversity * 2.5 * 0.1) + -- 10% weight on diversity (max 10 industries)
            (LEAST(avg_hourly_rate / 2, 25) * 0.1) -- 10% weight on hourly rate potential
        , 1) as expansion_priority_score,
        CASE 
            WHEN active_businesses < 3 THEN 'High Risk - Limited Data'
            WHEN growth_rate_pct < -10 THEN 'Medium Risk - Declining'
            WHEN market_penetration_pct > 30 THEN 'Low Risk - Proven Market'
            ELSE 'Medium Risk'
        END as risk_assessment
    FROM expansion_analysis
)
SELECT 
    location,
    active_businesses,
    estimated_total_businesses,
    market_penetration_pct,
    revenue_per_business,
    growth_rate_pct,
    industry_diversity,
    ROUND(addressable_market_value, 0) as addressable_market_value,
    expansion_priority_score,
    ROW_NUMBER() OVER (ORDER BY expansion_priority_score DESC) as expansion_rank,
    risk_assessment,
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY expansion_priority_score DESC) <= 3 THEN '🎯 Top Priority'
        WHEN ROW_NUMBER() OVER (ORDER BY expansion_priority_score DESC) <= 5 THEN '📈 High Priority' 
        WHEN ROW_NUMBER() OVER (ORDER BY expansion_priority_score DESC) <= 10 THEN '📊 Medium Priority'
        ELSE '📋 Monitor'
    END as recommendation
FROM priority_scoring
WHERE active_businesses > 0 OR expansion_priority_score > 20
ORDER BY expansion_priority_score DESC
LIMIT 15;
```

## ---

### 📝 Key Concepts Explained:

* **Market sizing:** Estimates total addressable market based on current penetration
* **Multi-factor scoring:** Combines growth, market size, competition, and potential
* **Logarithmic scaling:** Prevents very large markets from dominating the score
* **Risk assessment:** Balances opportunity with execution risk
* **Dynamic multipliers:** Market potential calculation adjusts based on market maturity

### 💼 Business Impact:

Provides data-driven prioritization for geographic expansion, helping Traba allocate limited resources to highest-ROI markets.

---

## 🎯 Interview Success Tips

### Technical Excellence

1. **Window Function Mastery:** Use appropriate frames (ROWS vs RANGE)
2. **NULL Handling:** Always use COALESCE for robust calculations
3. **Performance Considerations:** Consider indexing strategies for large datasets
4. **Data Types:** Use proper casting (::numeric) for precise calculations

### Business Acumen

1. **Marketplace Thinking:** Always consider both sides of the platform
2. **Scalability:** Show how your queries support rapid growth
3. **Actionable Insights:** Connect analytics to business decisions
4. **KPI Focus:** Align metrics with business objectives

### Communication

1. **Explain Your Approach:** Walk through your thought process
2. **Handle Edge Cases:** Discuss NULL values and data quality
3. **Alternative Solutions:** Mention different approaches you considered
4. **Optimization:** Discuss how to make queries production-ready

### Follow-up Questions to Expect

* "How would you optimize this query for production?"
* "What assumptions did you make about the data?"
* "How would you handle missing or inconsistent data?"
* "What would you do if this query was running slowly?"
* "How would you turn this into a real-time dashboard?"

### Key Traba Themes to Emphasize

* **Operational Excellence**
* **Data-Driven Decisions**
* **Scalable Solutions**
* **Customer Success**
* **Innovation**

---

## 🔍 Deep Dive: Advanced SQL Concepts Used

```sql
-- Different frame types for different purposes
AVG() OVER (ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)  -- Rolling average
SUM() OVER (ORDER BY date)  -- Running total
RANK() OVER (PARTITION BY category ORDER BY value DESC)  -- Ranking within groups
LAG() OVER (PARTITION BY id ORDER BY date)  -- Previous value comparison
```

## ---

```sql
-- Multi-stage data processing
WITH raw_data AS (...),
     aggregated AS (...),
     calculated AS (...),
     final_scores AS (...)
SELECT * FROM final_scores;
```

## ---

```sql
-- Standard deviation for consistency
STDDEV(rating) as rating_consistency

-- Linear regression slope approximation
(COUNT(*) * SUM(x * y) - SUM(x) * SUM(y)) / 
(COUNT(*) * SUM(x * x) - SUM(x) * SUM(x)) as trend_slope

-- Percentile calculations
PERCENT_RANK() OVER (ORDER BY value) as percentile
NTILE(4) OVER (ORDER BY value) as quartile
```

---

## 📊 Business Metrics Explained

### Marketplace Health Indicators

* **Supply-Demand Ratio**
* **Time-to-Fill**
* **Utilization Rate**
* **Churn Rate**

### Growth Metrics

* **WoW/MoM Growth**
* **Cohort Retention**
* **LTV\:CAC Ratio**
* **Market Penetration**

### Operational Efficiency

* **Completion Rate**
* **Average Rating**
* **Response Time**
* **Capacity Shortage**

---

## 🎯 Interview Scenario Practice

### Scenario 1: Performance Problem

**Approach:** Index strategy, query rewrite, partitioning, materialized views.

### Scenario 2: Data Quality Issues

**Approach:** NULL handling, data validation, edge cases, testing.

### Scenario 3: Business Stakeholder Questions

**Approach:** Business context, plain English, visual story, action items.

---

## 💡 Additional SQL Interview Questions for Traba

**Q1:** How would you find workers who have never had a shift cancelled?

```sql
SELECT w.worker_id, w.name
FROM workers w
WHERE NOT EXISTS (
    SELECT 1 FROM shifts s 
    WHERE s.worker_id = w.worker_id 
    AND s.status = 'cancelled'
);
```

## ---

**Q2:** What's the median hourly rate by location?

```sql
SELECT location,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY hourly_rate) as median_rate
FROM job_posts jp
JOIN businesses b ON jp.business_id = b.business_id
GROUP BY location;
```

## ---

**Q3:** Find businesses with above-average retention rates:

```sql
WITH retention_rates AS (
    SELECT business_id,
           COUNT(DISTINCT worker_id) as unique_workers,
           COUNT(DISTINCT worker_id) FILTER (WHERE shift_count > 1) as returning_workers
    FROM (
        SELECT jp.business_id, s.worker_id, COUNT(*) as shift_count
        FROM job_posts jp
        JOIN shifts s ON jp.job_id = s.job_id
        WHERE s.status = 'completed'
        GROUP BY jp.business_id, s.worker_id
    ) worker_shifts
    GROUP BY business_id
),
avg_retention AS (
    SELECT AVG(returning_workers::numeric / NULLIF(unique_workers, 0)) as market_avg
    FROM retention_rates
)
SELECT rr.business_id, 
       rr.returning_workers::numeric / rr.unique_workers as retention_rate
FROM retention_rates rr
CROSS JOIN avg_retention ar
WHERE rr.returning_workers::numeric / rr.unique_workers > ar.market_avg;
```

---

## 🚀 Advanced Topics to Discuss

* **Data Architecture Considerations:** Real-time vs batch, warehouse design, governance, privacy
* **Modern Data Stack Integration:** dbt, BI tools, cataloging, version control
* **Machine Learning Applications:** Feature engineering, validation, A/B testing, scoring
* **Scaling Considerations:** Performance, freshness, cost, monitoring

---

## 📝 Final Interview Preparation Checklist

### Technical Preparation

* Practice all 7 problems
* Understand business context
* Be ready to optimize queries
* Handle data quality issues

### Business Preparation

* Research Traba & competitors
* Know industry trends
* Prepare infra questions
* Tie analytics to growth

### Behavioral Preparation

* Examples of data-driven impact
* Influencing strategy
* Cross-functional collaboration
* Curiosity for complex problems

### Questions to Ask Them

1. Biggest data challenges today?
2. How does data collaborate with product/ops?
3. Vision for analytics next year?
4. How do you measure success of data initiatives?
5. What tools/tech excite the team?

---

## 🎯 The Traba Mindset

* **Curiosity, Ownership, Impact, Collaboration, Growth**
* Success metrics: marketplace efficiency, quality outcomes, growth enablement, operational excellence, strategic vision
