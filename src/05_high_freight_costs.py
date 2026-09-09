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

# following from the 05_distribution_check.py script, we will use the iqr method 
# to compute the extreme values for avg_freight_cost and total_late_deliveries 

# delay_q1 = df['total_late_deliveries'].quantile(0.25)
# delay_q3 = df['total_late_deliveries'].quantile(0.75)
# delay_iqr = delay_q3 - delay_q1 

# checking for any 0-clustered values, un-comment to check 
# print(delay_q1, delay_q3, delay_iqr)
# the output for this was 0.0, 4.0, 4.0
# it doesn't make sense to use the 0.25 or 0.75 quantile since most values will be flagged 
# sticking to a higher quantile 0.99 for both so that we only catch the absolute outliers 

df['combined_label'] = df['customer_state'] + " - " + df['product_category_name_english']

# computing the extreme quantile thresholds (refer to above comments for reasoning)

delay_threshold = df['total_late_deliveries'].quantile(0.99)
cost_threshold = df['avg_freight_cost'].quantile(0.99)

# creating the scatter plot 
plt.figure(figsize=(14,8))
plt.scatter(
    x=df['avg_freight_cost'],
    y=df['total_late_deliveries'],
    alpha=0.6,
    s=80,
    color='steelblue'
)

# doing the outlier check and adding text next to the dot 

for i in range(len(df)):
    cost = df['avg_freight_cost'].iloc[i]
    delays = df['total_late_deliveries'].iloc[i]
    label = df['combined_label'].iloc[i]

    if delays > delay_threshold or cost > cost_threshold:
        plt.text(cost + 1, delays + 2, label, fontsize=9)

plt.title('Top 1% Worst Freight Costs & Delays', fontsize=16)
plt.xlabel('Average Freight Cost (BRL)', fontsize=12)
plt.ylabel('Total Late Deliveries', fontsize=12)

# drawing the 99th percentile boundary lines 
plt.axvline(x=cost_threshold, color='red', linestyle='--', alpha=0.5, label=f"Top 1% Cost Limit ({cost_threshold: .1f})")
plt.axhline(y=delay_threshold, color='orange', linestyle='--', alpha=0.5, label=f"Top 1% Deliveries Delayed ({delay_threshold: .1f})")

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/05_high_freight_costs.png', dpi=300)
print('Image saved to the given folder.')
