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

