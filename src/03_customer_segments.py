# question we're considering for this: 
# 3. Which customer segments have the highest average order value? 

import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

# duckdb for importing tables 
con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT loyalty_segment, payment_segment, avg_order_value 
    FROM question_three 
""").df()

# creating a pivot table as we want to compare values side by side (wide format)
pivot_df = df.pivot_table(
    index='loyalty_segment',
    columns='payment_segment',
    values='avg_order_value',
    aggfunc='mean'
)

pivot_df.plot(kind='bar', stacked=False, figsize=(12, 7), colormap='plasma')
plt.title('Customer Segments with the Highest Average Order Value', fontsize=16)
plt.xlabel('Loyalty Segment', fontsize=12)
plt.ylabel('Average Order Value (BRL)', fontsize=12)
plt.xticks(rotation=0)
plt.legend(title='Payment Method')
plt.tight_layout()

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/customer_segments_avg_order_value.png', dpi=300)
df.to_csv('/home/priyansh/Documents/d/ecommerce dashboard/notebooks/03_customer_segments.csv')
print('Image saved to figures/')
print('03_customer_segments.csv saved to notebooks/')

