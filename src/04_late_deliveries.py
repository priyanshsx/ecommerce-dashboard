# question to tackle: 
# are late deliveries associated with lower review scores?

import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

# duckdb for importing tables 
con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT delivery_status, avg_review_score, total_orders 
    FROM question_four 
""").df()

plt.figure(figsize=(10, 6))

# plotting a bar chart for comparison
plt.bar(x=df['delivery_status'], height=df['avg_review_score'], color=['#ff9999', '#66b3ff'])

# chart details 
plt.title('Impact of Delivery Delays on Customer Reviews', fontsize=16)
plt.xlabel('Delivery Status', fontsize=12)
plt.ylabel('Average Review Score (/5)', fontsize=12)

plt.ylim(0, 5) # to not let the chart get cut off 

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/delivery_delays_review_scores.png', dpi=300)
df.to_csv('/home/priyansh/Documents/d/ecommerce dashboard/notebooks/04_late_deliveries.csv')
print('Image saved to figures/')
print('04_high_freight_costs.csv saved to notebooks/')

