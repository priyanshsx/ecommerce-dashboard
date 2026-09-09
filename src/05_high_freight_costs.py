# question to tackle
# Which categories or regions experience disproportionately high freight costs or delivery delays? 

import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

# duckdb for importing tables 
con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT product_category_name_english, customer_state, avg_freight_cost, total_late_deliveries 
    FROM question_five 
""").df()

# here we group by state 2 things: sum of total late deliveries and the avg of freight costs 
state_summary = df.groupby('customer_state').agg({
    'total_late_deliveries': 'sum',
    'avg_freight_cost': 'mean'
})

state_summary.plot(
    kind='scatter',
    x='avg_freight_cost',
    y='total_late_deliveries',
    figsize=(10,6),
    s=100,
    alpha=0.7  
)

# chart details 
plt.title('Regions with High Freight Costs or Delivery Delays', fontsize=16)
plt.xlabel('Average Freight Cost', fontsize=12)
plt.ylabel('Total Late Deliveries', fontsize=12)

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/freight_costs_delivery_delays.png', dpi=300)
print('Image saved to the given folder.')

