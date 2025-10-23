create database ecommerce;
use ecommerce;
describe ecommerce_sales;
select * from ecommerce_sales;

-- making copy of data in sql  
 create table ecommerce_copy as 
 select * from ecommerce_sales;
 
 -- show all from data 
 select * from ecommerce_copy;
 
 -- changing data types of column 
 Alter table ecommerce_copy
 modify column quantity Int;
 
 -- while altering datatypes blanks are truncated now will replace balnk by '0'
 update ecommerce_copy
 set discount ='0.0'
 where discount ='' or discount is NULL;
 
 update ecommerce_copy
 set price ='0'
 where price ='' or price is Null;
 
 update ecommerce_copy
 set payment_method ='other'
 where payment_method ='' or payment_method is NULL ;
 
 update ecommerce_copy
 set region ='other'
 where region ='' or region is Null;
 
 update ecommerce_copy
 set discount = cast(replace(discount,'%','')as decimal(6,4))/100
 where discount like '%\%';
 
 update ecommerce_copy
 set profit_margin ='0'
 where profit_margin =''or profit_margin is  null;

update ecommerce_copy
set discount= cast(discount as decimal(5,4))
where discount;
 
 update ecommerce_copy
 set customer_age = '0'
 where customer_age ='' or customer_age is NUll;
 -- Another change 
  select delivery_time_days,count(delivery_time_days) 
  from ecommerce_copy 
  group by delivery_time_days;

 update ecommerce_copy
 set delivery_time_days =
  case 
  when delivery_time_days ='NaN' then '0'
  when delivery_time_days ='unknown' then '0'
  when delivery_time_days ='five' then '5'
  else delivery_time_days
  end;
  
  select cast(avg(delivery_time_days) as decimal) from ecommerce_copy;
  
  update ecommerce_copy as ec
  set delivery_time_days = 5
  where delivery_time_days = 0;
  
  update ecommerce_copy
  set returned = 'NA'
  where returned ='';
  select returned ,count(returned) from ecommerce_copy group by returned;
 select * from ecommerce_copy;


-- modifying or changing datatypes 
 Alter table ecommerce_copy
 modify column price Double;

 Alter table ecommerce_copy
 modify column discount Double;
 
 Alter table ecommerce_copy
 modify column delivery_time_days INT;
 

 Alter table ecommerce_copy 
 modify column customer_age Int;
 
 
  Alter table ecommerce_copy
  modify column order_date Date;
  
  Alter table ecommerce_copy
  modify column profit_margin double;
  
  Alter table ecommerce_copy
  modify column total_amount double;
  Alter table ecommerce_copy
  modify column shipping_cost double;

 select distinct profit_margin from ecommerce_copy;
 
 SELECT 
    ROW_NUMBER() OVER (ORDER BY order_id) AS row_num,
    order_id,
    COUNT(*) AS order_count
FROM ecommerce_copy
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT 
    ROW_NUMBER() OVER (ORDER BY order_id) AS sr_no,
    order_id, customer_id, product_id, order_date, quantity, price, discount,category,payment_method,delivery_time_days,region,returned,total_amount,shipping_cost,profit_margin,customer_age,customer_gender,
    COUNT(*) AS duplicate_count
FROM ecommerce_copy
GROUP BY 
    order_id, customer_id, product_id, order_date, quantity, price, discount,category,payment_method,delivery_time_days,region,returned,total_amount,shipping_cost,profit_margin,customer_age,customer_gender
HAVING COUNT(*) > 1;

 select * from ecommerce_copy
 where order_id ='O117505';
 
 
 select distinct region,count(region) from ecommerce_copy
 group by region ;
 select count(region) from ecommerce_copy;

 update ecommerce_copy
 set region = case
  when region ='Weest' then 'West'
  when region ='WEST' then 'West'
  when region ='Souuth' then 'South'
   when region ='south' then 'South'
    when region ='east' then 'East'
     when region ='north' then 'North'
      when region ='N0rth' then 'North'
      when region = 'Wst' then 'West'
       when region ='Noth' then 'North'
        when region ='Suth' then 'South'
         when region ='Eaast' then 'East'
         when region ='Est' then 'East'
         when region ='other' then 'Other'
         else  region
          end;
		select * from ecommerce_copy;
      
      select payment_method,count(payment_method) from ecommerce_copy
      group by payment_method;
      
      update ecommerce_copy
      set payment_method = case 
      when payment_method in ('creditcard','Credt Card') then ('Credit Card')
      when payment_method in ('U.P.I','upi','UP','UPii') then ('UPI')
      when payment_method in ('PayPal','Wallet') then ('Wallet')
      when payment_method in ('CRD','Card') then ('Card') 
      when payment_method in ('C.O.D','Cash on Delivery','cod','Cash on Delvry' ) then ('Cash')
      when payment_method ='other' then 'Other'
      else payment_method 
      end;
      
      select count(order_id) from ecommerce_copy
      having count(*)>1;
      start transaction;
      UPDATE ecommerce_copy
SET order_date = COALESCE(
    STR_TO_DATE(order_date, '%d %b %Y'),
    STR_TO_DATE(order_date, '%d/%m/%Y'),
    STR_TO_DATE(order_date, '%d-%m-%Y'),
    STR_TO_DATE(order_date, '%Y-%m-%d')
);
update ecommerce_copy
set order_date =case 
when order_date REGEXP '^[0-9]{1,2} [A-Za-z]{3} [0-9]{4}$' then str_to_date(order_date,'%d %b %Y')
else order_date
end;
UPDATE ecommerce_copy
SET order_date = CASE
    -- Format: mm/dd/yyyy or dd/mm/yyyy
    WHEN order_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN
        CASE
            -- If first part > 12, it's dd/mm/yyyy
            WHEN CAST(SUBSTRING_INDEX(order_date,'/',1) AS UNSIGNED) > 12 
                THEN STR_TO_DATE(order_date, '%d/%m/%Y')
            -- Else assume mm/dd/yyyy
            ELSE STR_TO_DATE(order_date, '%m/%d/%Y')
        END

    -- Format: 23 Dec 2024
    WHEN order_date REGEXP '^[0-9]{1,2} [A-Za-z]{3} [0-9]{2,4}$'
        THEN STR_TO_DATE(order_date, '%d %b %Y')

    -- Format: dd-mm-yy
    WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(order_date, '%d-%m-%y')

    ELSE order_date
END;

select * from ecommerce_copy;


rollback;
