DELETE FROM sale_details
WHERE daily_sale_id IN (
    SELECT id FROM daily_sales
    WHERE sale_date BETWEEN '2026-03-10' AND '2026-04-11'
    AND is_closed = true
);

DELETE FROM daily_sales
WHERE sale_date BETWEEN '2026-03-10' AND '2026-04-11'
AND is_closed = true;

DO $$
DECLARE
  ds UUID;
  s UUID := '5e5e5041-e788-4a1d-8048-82bc90b5157f';
  pc UUID := '779e0029-f398-42ac-9eac-ebd3af442373';
  pg UUID := 'c887a890-d81a-483e-8537-0db3b9a244d6';
  pp UUID := '7c38266b-13c3-4e1f-965b-457270d99869';
  pk UUID := '6c031a23-fee5-412b-9e6b-dcdda811c899';
BEGIN

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-02-24',150.00,100.08,0,true,'2026-02-24 17:00+00','2026-02-24 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,4,4,0,15.02,20.00,'2026-02-24 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-02-24 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-02-25',255.00,175.10,0,true,'2026-02-25 17:00+00','2026-02-25 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,5,5,0,15.02,20.00,'2026-02-25 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,3,3,0,20.00,35.00,'2026-02-25 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,2,2,0,20.00,25.00,'2026-02-25 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-02-26',130.00,85.06,0,true,'2026-02-26 17:00+00','2026-02-26 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,3,3,0,15.02,20.00,'2026-02-26 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-02-26 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-02-27',260.00,230.12,15.02,true,'2026-02-27 17:00+00','2026-02-27 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,7,6,1,15.02,20.00,'2026-02-27 17:00+00','expired',15.02),(gen_random_uuid(),ds,pg,4,4,0,20.00,35.00,'2026-02-27 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-02-28',520.00,345.14,0,true,'2026-02-28 17:00+00','2026-02-28 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,7,7,0,15.02,20.00,'2026-02-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,5,5,0,20.00,35.00,'2026-02-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,3,3,0,20.00,35.00,'2026-02-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,4,4,0,20.00,25.00,'2026-02-28 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-03',130.00,85.06,0,true,'2026-03-03 17:00+00','2026-03-03 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,3,3,0,15.02,20.00,'2026-03-03 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-03-03 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-04',245.00,175.10,0,true,'2026-03-04 17:00+00','2026-03-04 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,5,5,0,15.02,20.00,'2026-03-04 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-04 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,3,3,0,20.00,25.00,'2026-03-04 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-05',185.00,160.08,20.00,true,'2026-03-05 17:00+00','2026-03-05 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,4,4,0,15.02,20.00,'2026-03-05 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,4,3,1,20.00,35.00,'2026-03-05 17:00+00','expired',20.00);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-06',225.00,150.12,0,true,'2026-03-06 17:00+00','2026-03-06 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,6,6,0,15.02,20.00,'2026-03-06 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-03-06 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,1,1,0,20.00,35.00,'2026-03-06 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-07',585.00,400.16,0,true,'2026-03-07 17:00+00','2026-03-07 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,8,8,0,15.02,20.00,'2026-03-07 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,5,5,0,20.00,35.00,'2026-03-07 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,3,3,0,20.00,35.00,'2026-03-07 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,5,5,0,20.00,25.00,'2026-03-07 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-10',95.00,85.06,40.00,true,'2026-03-10 17:00+00','2026-03-10 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,3,3,0,15.02,20.00,'2026-03-10 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,3,1,2,20.00,35.00,'2026-03-10 17:00+00','expired',40.00);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-11',255.00,175.10,0,true,'2026-03-11 17:00+00','2026-03-11 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,5,5,0,15.02,20.00,'2026-03-11 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,3,3,0,20.00,35.00,'2026-03-11 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,2,2,0,20.00,25.00,'2026-03-11 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-12',185.00,120.08,0,true,'2026-03-12 17:00+00','2026-03-12 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,4,4,0,15.02,20.00,'2026-03-12 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,3,3,0,20.00,35.00,'2026-03-12 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-13',255.00,170.04,0,true,'2026-03-13 17:00+00','2026-03-13 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,2,2,0,15.02,20.00,'2026-03-13 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,4,4,0,20.00,35.00,'2026-03-13 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,3,3,0,20.00,25.00,'2026-03-13 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-14',505.00,355.18,0,true,'2026-03-14 17:00+00','2026-03-14 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,6,6,0,15.02,20.00,'2026-03-14 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,5,5,0,20.00,35.00,'2026-03-14 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-14 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,4,4,0,20.00,25.00,'2026-03-14 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-17',175.00,120.08,0,true,'2026-03-17 17:00+00','2026-03-17 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,4,4,0,15.02,20.00,'2026-03-17 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-03-17 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,1,1,0,20.00,25.00,'2026-03-17 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-18',205.00,175.10,20.00,true,'2026-03-18 17:00+00','2026-03-18 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,5,5,0,15.02,20.00,'2026-03-18 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,3,2,1,20.00,35.00,'2026-03-18 17:00+00','expired',20.00),(gen_random_uuid(),ds,pk,2,1,1,20.00,25.00,'2026-03-18 17:00+00','expired',20.00);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-19',240.00,165.06,0,true,'2026-03-19 17:00+00','2026-03-19 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,3,3,0,15.02,20.00,'2026-03-19 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,3,3,0,20.00,35.00,'2026-03-19 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,3,3,0,20.00,25.00,'2026-03-19 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-20',260.00,170.12,0,true,'2026-03-20 17:00+00','2026-03-20 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,6,6,0,15.02,20.00,'2026-03-20 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-03-20 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-20 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-21',430.00,360.16,30.04,true,'2026-03-21 17:00+00','2026-03-21 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,10,8,2,15.02,20.00,'2026-03-21 17:00+00','expired',30.04),(gen_random_uuid(),ds,pg,3,3,0,20.00,35.00,'2026-03-21 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-21 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,4,4,0,20.00,25.00,'2026-03-21 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-24',150.00,100.08,0,true,'2026-03-24 17:00+00','2026-03-24 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,4,4,0,15.02,20.00,'2026-03-24 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,2,2,0,20.00,35.00,'2026-03-24 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-25',255.00,175.10,0,true,'2026-03-25 17:00+00','2026-03-25 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,5,5,0,15.02,20.00,'2026-03-25 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,3,3,0,20.00,35.00,'2026-03-25 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,2,2,0,20.00,25.00,'2026-03-25 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-26',155.00,105.06,0,true,'2026-03-26 17:00+00','2026-03-26 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,3,3,0,15.02,20.00,'2026-03-26 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-26 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,1,1,0,20.00,25.00,'2026-03-26 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-27',280.00,185.14,20.00,true,'2026-03-27 17:00+00','2026-03-27 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,7,7,0,15.02,20.00,'2026-03-27 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,4,3,1,20.00,35.00,'2026-03-27 17:00+00','expired',20.00),(gen_random_uuid(),ds,pp,1,1,0,20.00,35.00,'2026-03-27 17:00+00',NULL,0);

ds := gen_random_uuid();
INSERT INTO daily_sales (id,seller_id,sale_date,total_revenue,total_investment,total_waste_cost,is_closed,created_at,updated_at) VALUES (ds,s,'2026-03-28',430.00,290.12,0,true,'2026-03-28 17:00+00','2026-03-28 17:00+00');
INSERT INTO sale_details (id,daily_sale_id,product_id,quantity_prepared,quantity_sold,quantity_lost,unit_cost,unit_price,created_at,waste_reason,waste_cost) VALUES (gen_random_uuid(),ds,pc,6,6,0,15.02,20.00,'2026-03-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pg,4,4,0,20.00,35.00,'2026-03-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pp,2,2,0,20.00,35.00,'2026-03-28 17:00+00',NULL,0),(gen_random_uuid(),ds,pk,4,4,0,20.00,25.00,'2026-03-28 17:00+00',NULL,0);

RAISE NOTICE '25 dias reinsertados OK (Feb 24 - Mar 28)';
END;
$$;

SELECT sale_date, total_revenue, total_waste_cost, is_closed
FROM daily_sales
ORDER BY sale_date;