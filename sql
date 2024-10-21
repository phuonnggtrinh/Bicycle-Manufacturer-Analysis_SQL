
-- Query 1: Calc Quantity of items, Sales value & Order quantity by each Subcategory in L12M**
select FORMAT_DATETIME("%b %Y",a.ModifiedDate) as period
      ,c.Name 
      ,sum(a.OrderQty) as qty_item
      ,sum(a.LineTotal) as total_sales
      ,count(distinct a.SalesOrderID) as order_qty
from `adventureworks2019.Sales.SalesOrderDetail` as a
left join `adventureworks2019.Production.Product` as b 
  on a.ProductID = b.ProductID
left join `adventureworks2019.Production.ProductSubcategory` as c
  on cast(b.ProductSubcategoryID as int) = c.ProductSubcategoryID
group by 1,2
order by 1 desc;

-- Query 2 : Calc % YoY growth rate by SubCategory & release top 3 cat with highest grow rate. Can use metric: quantity_item. Round results to 2 decimal

with sale_info as (
    SELECT 
        FORMAT_TIMESTAMP("%Y", a.ModifiedDate) as yr
        , c.Name
        , sum(a.OrderQty) as qty_item
    FROM `adventureworks2019.Sales.SalesOrderDetail` a 
    LEFT JOIN `adventureworks2019.Production.Product` b on a.ProductID = b.ProductID
    LEFT JOIN `adventureworks2019.Production.ProductSubcategory` c on cast(b.ProductSubcategoryID as int) = c.ProductSubcategoryID
    GROUP BY 1,2
    ORDER BY 2 asc , 1 desc)

, sale_diff as (
    select *
    , lead (qty_item) over (partition by Name order by yr desc) as prv_qty
    , round(qty_item / (lead (qty_item) over (partition by Name order by yr desc)) -1,2) as qty_diff
    from sale_info
    order by 5 desc )

,rk_qty_diff as (
    select *
        ,dense_rank() over( order by qty_diff desc) dk
    from sale_diff)

select distinct Name
      , qty_item
      , prv_qty
      , qty_diff
      , dk
from rk_qty_diff 
where dk <=3
order by dk;

--- Query 3: Ranking Top 3 TeritoryID with the biggest Order quantity every year. If there's TerritoryID with the same quantity in a year, do not skip the rank number
with raw_data as (
    select FORMAT_DATETIME("%Y",a.ModifiedDate) as period
          ,c.TerritoryID
          ,sum(a.OrderQty) as qty_item
    from `adventureworks2019.Sales.SalesOrderDetail` as a
    left join `adventureworks2019.Production.Product` as b 
      on a.ProductID = b.ProductID
    left join `adventureworks2019.Sales.SalesOrderHeader` as c
      on a.SalesOrderID = c.SalesOrderID
    group by 1,2
    order by 1,3 desc)

, ranking_quantity as (
 select *
      ,dense_rank() over(partition by period order by qty_item desc) as rk
from raw_data
order by period desc)

select * 
from ranking_quantity
where rk <=3;

--- Query 4: Calculate the Total Discount Cost belonging to the Seasonal Discount for each SubCategory

select 
    FORMAT_TIMESTAMP("%Y", ModifiedDate)
    , Name
    , sum(disc_cost) as total_cost
from (
      select distinct a.*
      , c.Name
      , d.DiscountPct, d.Type
      , a.OrderQty * d.DiscountPct * UnitPrice as disc_cost 
      from `adventureworks2019.Sales.SalesOrderDetail` a
      LEFT JOIN `adventureworks2019.Production.Product` b on a.ProductID = b.ProductID
      LEFT JOIN `adventureworks2019.Production.ProductSubcategory` c on cast(b.ProductSubcategoryID as int) = c.ProductSubcategoryID
      LEFT JOIN `adventureworks2019.Sales.SpecialOffer` d on a.SpecialOfferID = d.SpecialOfferID
      WHERE lower(d.Type) like '%seasonal discount%' 
)
group by 1,2;

--- Query 5: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)
with 
info as (
  select  
      extract(month from ModifiedDate) as month_no
      , extract(year from ModifiedDate) as year_no
      , CustomerID
      , count(Distinct SalesOrderID) as order_cnt
  from `adventureworks2019.Sales.SalesOrderHeader`
  where FORMAT_TIMESTAMP("%Y", ModifiedDate) = '2014'
  and Status = 5
  group by 1,2,3
  order by 3,1 
),
row_num as (
  select *
      , row_number() over (partition by CustomerID order by month_no) as row_numb
  from info 
), 
first_order as (
  select *
  from row_num
  where row_numb = 1
), 
month_gap as (
  select 
      a.CustomerID
      , b.month_no as month_join
      , a.month_no as month_order
      , a.order_cnt
      , concat('M - ',a.month_no - b.month_no) as month_diff
  from info a 
  left join first_order b 
  on a.CustomerID = b.CustomerID
  order by 1,3
)
select month_join
      , month_diff 
      , count(distinct CustomerID) as customer_cnt
from month_gap
group by 1,2
order by 1,2;

-- Query 6: Trend of Stock level & MoM diff % by all product in 2011. If the % growth rate is null then 0. Round to 1 decimal

with raw_data as ( 
    select a.Name
          ,extract(month from b.ModifiedDate) as month
          ,extract(year from b.ModifiedDate) as year
          , sum(StockedQty) as stock_qty
    from `adventureworks2019.Production.Product` as a
    left join `adventureworks2019.Production.WorkOrder` as b
      on a.ProductID = b.ProductID
    where extract(year from b.ModifiedDate) = 2011
    group by 1,2,3
    order by 2 desc)

,previous_quantity as (
    select *
          ,lag(stock_qty) over(partition by Name order by month) as stock_prv
    from raw_data
    order by month desc)

select * , ifnull (round(100.0 * (stock_qty - stock_prv) / stock_prv,1),0.0) as diff
from previous_quantity
order by Name, month desc; 

-- Query 7: "Calculate the Ratio of Stock / Sales in 2011 by product name, by month. Order results by month desc, ratio desc. Round Ratio to 1 decimal mom YoY"
with 
sale_info as (
  select 
      extract(month from a.ModifiedDate) as mth 
     , extract(year from a.ModifiedDate) as yr 
     , a.ProductId
     , b.Name
     , sum(a.OrderQty) as sales
  from `adventureworks2019.Sales.SalesOrderDetail` a 
  left join `adventureworks2019.Production.Product` b 
    on a.ProductID = b.ProductID
  where FORMAT_TIMESTAMP("%Y", a.ModifiedDate) = '2011'
  group by 1,2,3,4
), 

stock_info as (
  select
      extract(month from ModifiedDate) as mth 
      , extract(year from ModifiedDate) as yr 
      , ProductId
      , sum(StockedQty) as stock_cnt
  from `adventureworks2019.Production.WorkOrder`
  where FORMAT_TIMESTAMP("%Y", ModifiedDate) = '2011'
  group by 1,2,3
)

select
      a.*
    , coalesce(b.stock_cnt,0) as stock
    , round(coalesce(b.stock_cnt,0) / sales,2) as ratio
from sale_info a 
full join stock_info b 
  on a.ProductId = b.ProductId
and a.mth = b.mth 
and a.yr = b.yr
order by 1 desc, 7 desc;

-- Query 8: No of order and value at Pending status in 2014

select extract(year from ModifiedDate) as year
      ,Status
      ,count(distinct PurchaseOrderID) as order_cnt
      ,sum(TotalDue) as value
from `adventureworks2019.Purchasing.PurchaseOrderHeader`
where Status = 1
  and extract(year from ModifiedDate) = 2014
group by 1,2 ;
