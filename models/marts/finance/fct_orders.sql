select 
    order_id,
    customer_id,
    stripe.amount
from {{ref('stg_jaffle_shop__orders')}} as orders
LEFT JOIN {{ref('stg_stripe__payments')}} as stripe ON stripe.orderid = orders.order_id 