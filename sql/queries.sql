select * from walmart;

-- How do different payment methods contribute to overall sales volume and transaction frequency?
with total_transaction as (
    select count(*) as total_transaction
    from walmart
)
select 
    payment_method,
    sum(quantity) as quantity_sold,
    round(count(payment_method)/total_transaction*100,2) as percent_of_transaction
from walmart,total_transaction
group by payment_method;

```This question encourages a deeper understanding of consumer preferences for payment methods and how 
those preferences might impact sales performance. Additionally, it could lead to insights about optimizing payment 
options for increased customer satisfaction and sales.```

-- Count distinct branches
select COUNT(DISTINCT Branch) as total_branches
from walmart;

'''Which Walmart branches generate the highest total revenue, and what strategies or 
characteristics do these top-performing branches share?'''

SELECT branch,city,round(sum(total_price),2) as total_revenue
from walmart
group by Branch
order by total_revenue desc;

```This question encourages exploration of not only the revenue figures but also the underlying factors that 
might contribute to the success of these branches, such as location, management practices, or product offerings.```


-- Which cities generate the highest average revenue per branch, and what factors might contribute to these differences?
SELECT city,round(sum(total_price),2) as total_revenue , count(*) as total_branches,
round(sum(total_price)/count(*),2) as avg_revenue
from walmart
group by city
order by avg_revenue desc;

```This question encourages deeper analysis by prompting you to consider not just the numbers, 
but also the potential reasons behind the variations in average revenue across different cities.```

```What are the top-rated product categories at each Walmart branch, and how can these insights inform 
inventory and marketing strategies?```

select Branch, category, avg_rating
from (
    select Branch, category, round(avg(rating),2) as avg_rating,
        rank() over (PARTITION BY Branch order by avg(rating) desc) as Rn
    from walmart
    GROUP BY Branch, category
) as ranked
where rn=1;

```This question encourages an exploration of customer preferences and satisfaction, prompting considerations 
for how to leverage popular categories to enhance sales, improve customer experience, and tailor marketing efforts 
to align with local interests.```

```What are the busiest days for Walmart branches, and how might these insights inform staffing and inventory 
management strategies?```
with busiest_day as (
    select Branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) as day,
        count(*) as no_of_transactions,
        RANK() over(partition by Branch order by count(*) desc) as rank
    from 
        walmart
    GROUP BY
        
        day
)
select
    Branch,
    day,
    no_of_transactions
from 
    busiest_day
where
    rank=1
ORDER BY no_of_transactions desc;

```This question highlights the practical applications of the data, prompting considerations of how to optimize operations
based on peak transaction days. It also encourages exploring potential correlations between busy days and factors like 
promotions, local events, or seasonal trends.
```

```How do product ratings vary by category across different cities, and what factors might influence these 
differences in consumer perception?```

SELECT
    city,
    category,round(avg(rating),2),
    max(rating),
    min(rating)
from 
    walmart
GROUP BY 
    city,
    category;

```This question encourages exploration of trends in customer satisfaction and can lead to insights about 
regional preferences, potential product issues, or the effectiveness of local marketing strategies. It also 
invites consideration of how to address disparities in ratings to enhance overall customer experience.```    

```Which product categories generate the highest total profit for Walmart, and what strategies can be implemented to 
enhance profitability in underperforming categories?```

select 
    category,round(sum(total_price*profit_margin),2) as total_profit
from 
    walmart
group by
    category
order by 
    total_profit desc

```This question encourages a deeper dive into the data, prompting you to explore potential factors influencing 
profit margins, such as pricing strategies, product placement, and marketing efforts, while also considering ways to 
improve performance in categories with lower profits.```

```What are the preferred payment methods at Walmart branches, and how might these preferences inform customer 
experience and payment system enhancements?```

with common_payment_method as (
    select
        branch,
        payment_method,
        count(*),
        rank() over(partition by branch order by count(*) desc) as rank
    from
        walmart
    group by 
        branch,
        payment_method
    )
SELECT
    Branch,
    payment_method as preferred_payment_method
from
    common_payment_method
where 
    rank=1;

```This question encourages exploration of customer behavior regarding payment options and could lead to 
insights on how to improve payment processing, enhance customer satisfaction, and potentially introduce new 
payment solutions that align with consumer preferences.```
  

```Q) How do invoice counts vary across different shifts at Walmart branches, and what implications might this have 
for staffing and inventory management?```
select 
    Branch,
    case 
        WHEN HOUR(time(time))<12 then 'Morning'
        when hour(time(time)) BETWEEN 12 and 17 then 'Afternoon'
        else 'Evening'
    end  as shift,
    count(*) as num_invoices
from
    walmart
GROUP BY Branch,shift
order by num_invoices desc;

```This question encourages exploration of patterns in customer activity throughout the day, prompting 
considerations on how to optimize employee scheduling and inventory levels based on peak transaction times.```

```Which Walmart branches have experienced the largest declines in revenue over the past years, and what 
factors might explain these downturns?```

with revenue as(
    select
        DISTINCT branch,
        round(sum(total_price),2) as revenue,
        year(STR_TO_DATE(date,'%d/%m/%Y')) as year
    from
        walmart
    group by 
        branch,year
    ),
previous_year_revenue as(
    select *,
        lag(revenue) over(partition by branch order by year) as previous_year_revenue
        from
            revenue
    )
select *,
    round((previous_year_revenue-revenue)/previous_year_revenue*100,2) as revenue_decrease_ratio
from
    previous_year_revenue
where year > 2020    
order by 
    revenue_decrease_ratio DESC
limit 5;

WITH revenue_2022 AS (
    SELECT 
        branch,year(STR_TO_DATE(date,'%d/%m/%Y')) as year,
        SUM(total_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,year,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;


```This question invites exploration into the reasons behind revenue decreases, such as changes in consumer behavior, 
competition, economic factors, or operational challenges. It also encourages further investigation into strategies for 
improving performance in the underperforming branches.```