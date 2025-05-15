with customers as (

     select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as ( 

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

payments as (

    select order_id, amount, status, customer_id 
    from {{ref('stg_stripe__payments')}} as stripe_payments
    left join orders using (order_id)
    where stripe_payments.status = 'success'

),
/*
final as (
    select
        sum(payments.amount) as lifetime_value
    from
        payments
    
    
)
*/

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) 
        as number_of_orders,
        sum(payments.amount) as lifetime_value 
    from customers

    left join customer_orders using (customer_id)
    left join payments using (customer_id)

    group by 
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        customer_orders.number_of_orders
)


select * from final