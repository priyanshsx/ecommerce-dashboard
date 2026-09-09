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

# checking the distribution type with the below code

df['avg_freight_cost'].plot(
    kind='hist',
    bins=30,
    figsize=(8,5),
    edgecolor='black'
)

plt.title('Distribution of freight costs')
plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/freight_cost_distribution_check.png', dpi=300)
print("PNG saved as freight_cost_distribution_check.png.")

plt.clf()

df['total_late_deliveries'].plot(
    kind='hist',
    bins=30,
    figsize=(8,5),
    edgecolor='black'
)

plt.title('Distribution of total late deliveries')
plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/total_late_deliveries_distribution_check.png', dpi=300)
print("PNG saved as total_late_deliveries_distribution_check.png")

# this gives a completely skewed view of the data and since mean and stdev can both be distorted in this
# we'll be using the iqr method to compute the extreme outliers
# please refer to the script: 05_high_freight_costs.py for further analysis 
