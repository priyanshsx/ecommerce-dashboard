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

# filtering out delivery delays and high freight costs
late_deliveries = df.groupby('customer_state')['total_late_deliveries'].sum()
high_freight_cost = df.groupby('product_category_name_english')['avg_freight_cost'].sum()

